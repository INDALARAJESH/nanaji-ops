resource "aws_instance" "pritunl_app" {
  for_each = local.pritunl_instances

  ami                    = data.aws_ami.cn_pritunl_app.id
  subnet_id              = each.value.subnet_id
  instance_type          = each.value.instance_type
  source_dest_check      = false
  vpc_security_group_ids = [data.aws_security_group.pritunl_internal.id, data.aws_security_group.pritunl_allow_udp.id]
  iam_instance_profile   = aws_iam_instance_profile.pritunl_app.name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }


  user_data = <<-EOT
    #!/bin/bash
    set -e
    echo "Setting hostname"
    hostnamectl set-hostname ${each.value.name}

    echo "Configuring Datadog agent"
    DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.dd_api_key_secret_name} --query SecretString --output text --region us-east-1)
    DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

    echo "api_key: $DD_API_KEY" | sudo tee /etc/datadog-agent/datadog.yaml >/dev/null
    echo "logs_enabled: true" | sudo tee -a /etc/datadog-agent/datadog.yaml >/dev/null
    echo "inventories_configuration_enabled: true" | sudo tee -a /etc/datadog-agent/datadog.yaml >/dev/null
    sudo systemctl enable datadog-agent

    echo "Configuring Threat Stack agent"
    THREATSTACK_KEY=$(aws secretsmanager get-secret-value --secret-id ${local.threatstack_key_secret_name} --query SecretString --output text --region ${data.aws_region.current.name})
    sudo tsagent setup --deploy-key=$THREATSTACK_KEY --ruleset="PCI Rule Set" && sudo systemctl start threatstack

    echo "Enabling Pritunl service"
    sudo systemctl enable pritunl

    echo "Running updates"
    sudo yum -y --disablerepo=* --enablerepo=amzn2-core update
    reboot
  EOT

  tags        = merge(local.common_tags, { "Name" = each.value.name })
  volume_tags = merge(local.common_tags, { "Name" = each.value.name })
  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

resource "aws_lb_target_group_attachment" "pritunl_https" {
  for_each = aws_instance.pritunl_app

  target_group_arn = data.aws_lb_target_group.pritunl_https_tg.arn
  target_id        = each.value.id
}

resource "aws_eip_association" "pritunl_eip" {
  for_each = aws_instance.pritunl_app

  instance_id   = each.value.id
  allocation_id = data.aws_eip.pritunl[each.key].id
}
