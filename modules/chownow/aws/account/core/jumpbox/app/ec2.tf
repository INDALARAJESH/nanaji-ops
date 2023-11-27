resource "aws_security_group" "jumpbox" {
  name        = local.name
  description = "${var.vpc_name} VPC jumpbox rules"
  vpc_id      = data.aws_vpc.selected.id

  tags = local.common_tags
}

resource "aws_security_group_rule" "jumpbox-allow-outbound" {
  type              = "egress"
  security_group_id = aws_security_group.jumpbox.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "jumpbox" {
  ami                         = data.aws_ami.cn_jumpbox.id
  subnet_id                   = data.aws_subnets.private.ids[0]
  instance_type               = var.instance_size
  vpc_security_group_ids      = concat([aws_security_group.jumpbox.id], var.additional_security_groups)
  iam_instance_profile        = aws_iam_instance_profile.jumpbox-ssm-profile.name
  user_data_replace_on_change = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e
    echo "Setting hostname"
    hostnamectl set-hostname ${local.name}

    echo "Configuring Datadog agent"
    DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.dd_api_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

    echo "api_key: $DD_API_KEY" | sudo tee /etc/datadog-agent/datadog.yaml >/dev/null
    echo "logs_enabled: true" | sudo tee -a /etc/datadog-agent/datadog.yaml >/dev/null
    echo "inventories_configuration_enabled: true" | sudo tee -a /etc/datadog-agent/datadog.yaml >/dev/null
    sudo systemctl enable datadog-agent

    echo "Configuring Threat Stack agent"
    THREATSTACK_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.threatstack_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    sudo tsagent setup --deploy-key=$THREATSTACK_KEY --ruleset="PCI Rule Set" && sudo systemctl start threatstack

    echo "Configuring Telport Database Service"
    SELFSIGNED_CERT_PASS=$(aws secretsmanager get-secret-value --secret-id ${local.teleport_selfsigned_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})

    sed -i 's/teleport_vpc/${var.vpc_name}/g' /etc/teleport.yaml  >/dev/null
    sed -i "s/datadog_api_key/$${DD_API_KEY}/g" /etc/fluent/fluentd.conf  >/dev/null
    sed -i "s/identity_passphrase/$${SELFSIGNED_CERT_PASS}/g" /etc/fluent/fluentd.conf  >/dev/null

    sudo systemctl disable machine-id
    sudo systemctl disable fluentd
    sudo systemctl disable teleport-event-handler

    if [ "${var.enable_teleport_event_handler}" == "true" ]; then
      cd /usr/bin/teleport-event-handler && openssl11 req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout selfsigned.key -out selfsigned.crt -subj '/C=US/CN=localhost' -addext 'subjectAltName=DNS:localhost,IP:127.0.0.1,IP:0:0:0:0:0:0:0:1' -addext 'extendedKeyUsage=serverAuth,clientAuth' -passin pass:$SELFSIGNED_CERT_PASS
      sudo systemctl enable machine-id
      sudo systemctl enable fluentd
      sudo systemctl enable teleport-event-handler
      sudo systemctl start machine-id
      sudo systemctl start fluentd
      sudo systemctl start teleport-event-handler
    fi

    sudo systemctl enable teleport
    sudo systemctl start teleport

    echo "Configuring Sysdig Secure agent"
    SYSDIG_ACCESS_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.sysdig_access_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    echo "customerid: $SYSDIG_ACCESS_KEY" | sudo tee -a /opt/draios/etc/dragent.yaml >/dev/null
    sudo systemctl enable dragent

    echo "Configuring Sysdig Host Scanner"
    echo "SYSDIG_ACCESS_KEY=$SYSDIG_ACCESS_KEY" | sudo tee -a /opt/draios/etc/vuln-host-scanner/env >/dev/null
    sudo systemctl enable vuln-host-scanner.service

    if [ "${var.enable_sysdig}" == "false" ]; then
      echo "Sysdig set to be not enabled, disabling services"
      sudo systemctl disable dragent
      sudo systemctl disable vuln-host-scanner.service
      echo "Removing Sysdig packages"
      sudo yum remove -y draios-agent
      sudo yum remove -y vuln-host-scanner
    fi

    echo "Running updates"
    sudo yum -y --disablerepo=* --enablerepo=amzn2-core update

    reboot
  EOT

  tags        = local.common_tags
  volume_tags = local.common_tags

  # lifecycle {
  #   ignore_changes = [ami, user_data]
  # }
}
