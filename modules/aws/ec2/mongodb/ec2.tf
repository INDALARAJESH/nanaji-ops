resource "aws_security_group" "sg" {
  name        = local.name
  description = "${local.name} security group rules"
  vpc_id      = data.aws_vpc.selected.id

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_security_group_rule" "egress-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "ingress-mongodb" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "ingress-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [for s in data.aws_subnet.private : s.cidr_block]
  security_group_id = aws_security_group.sg.id
}

resource "aws_instance" "ec2" {
  for_each = var.mongodb_instances

  ami                    = data.aws_ami.amazon_linux_2.id
  key_name               = data.aws_key_pair.ec2.key_name
  subnet_id              = each.value.subnet_id
  instance_type          = each.value.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  root_block_device {
    encrypted   = true
    volume_size = 100
    volume_type = "gp3"
  }


  user_data = <<-EOT
    #!/bin/bash
    set -e

    echo "setting hostname"
    hostnamectl set-hostname ${each.value.name}

    echo "configuring ebs volume"
    DISK_STATUS=$(sudo file -s /dev/nvme1n1)

    if [[ $DISK_STATUS == "/dev/nvme1n1: data" ]]; then
        echo "configuring empty disk"
        sudo mkfs -t xfs /dev/nvme1n1
        sudo mkdir /mnt/data
        sudo mount -t xfs /dev/nvme1n1 /mnt/data

        echo "configuring mongo data location"
        sudo mkdir /mnt/data/mongo
        sudo chown mongod:mongod /mnt/data/mongo
        sudo sed -i "s|/var/lib/mongo|/mnt/data/mongo|" /etc/mongod.conf
        sudo systemctl restart mongod

        echo "adding initialized EBS volume to fstab"
        EBS_UUID=$(lsblk -o NAME,UUID | grep nvme1n1 | cut -d ' ' -f 8)
        echo "UUID=$EBS_UUID /mnt/data xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
    else
      echo "disk has already been initialized"
    fi

    echo "enabling datadog agent to read mongodb log"
    sudo chmod o+rx /var/log/mongodb/mongod.log

    echo "configuring datadog agent"
    DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.dd_api_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
    echo "api_key: $DD_API_KEY" | sudo tee /etc/datadog-agent/datadog.yaml >/dev/null
    echo "logs_enabled: true" | sudo tee -a /etc/datadog-agent/datadog.yaml >/dev/null
    sudo systemctl enable datadog-agent

    echo "configuring threatstack agent"
    THREATSTACK_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.threatstack_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    sudo tsagent setup --deploy-key=$THREATSTACK_KEY --ruleset="PCI Rule Set" && sudo systemctl start threatstack

    echo "preventing unwanted mongo updates"
    echo "exclude=mongodb-org,mongodb-org-database,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools" | sudo tee -a /etc/yum.conf >/dev/null

    echo "increasing open file limits"
    echo "* hard nofile 64000" | sudo tee -a /etc/security/limits.conf >/dev/null
    echo "* soft nofile 64000" | sudo tee -a /etc/security/limits.conf >/dev/null
    echo "root hard nofile 64000" | sudo tee -a /etc/security/limits.conf >/dev/null
    echo "root soft nofile 64000" | sudo tee -a /etc/security/limits.conf >/dev/null

    echo "updating max map count per mongodb recommendation"
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.d/99-sysctl.conf >/dev/null

    echo "Update AWSCLI"
    cd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    sudo yum install -y jq

    echo "Adding mongobackup user"
    sudo adduser mongobackup

    echo "running updates"
    sudo yum -y --disablerepo=* --enablerepo=amzn2-core update
    sudo reboot now
  EOT

  tags = merge(local.common_tags, { "Name" = each.value.name })

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

#######################
# EBS Volume For Data #
#######################

resource "aws_ebs_volume" "data" {
  for_each = var.mongodb_instances

  availability_zone = aws_instance.ec2[each.key].availability_zone
  encrypted         = true
  size              = 100

  tags = merge(local.common_tags, { "Name" = each.value.name })
}


# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html#available-ec2-device-names
resource "aws_volume_attachment" "ec2_ebs_data" {
  for_each = var.mongodb_instances

  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = aws_instance.ec2[each.key].id
}


#######
# DNS #
#######

resource "aws_route53_record" "ec2_private_record" {
  for_each = var.mongodb_instances

  zone_id = data.aws_route53_zone.private.zone_id
  name    = "${var.service}-${each.key}.${var.dns_zone}."
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2[each.key].private_ip]

}
