resource "aws_instance" "vm" {
  count = var.instance_count

  ami                         = local.ami_id
  associate_public_ip_address = var.associate_public_ip_address
  disable_api_termination     = var.disable_api_termination
  iam_instance_profile        = local.iam_instance_profile
  instance_type               = var.instance_type
  key_name                    = local.key_pair
  monitoring                  = var.monitoring
  subnet_id                   = element(tolist(data.aws_subnets.private.ids), count.index) # distributes instances across AZs
  user_data                   = local.user_data
  vpc_security_group_ids      = concat(var.security_group_ids, [aws_security_group.vm.id])

  root_block_device {
    delete_on_termination = var.storage_delete_on_termination
    encrypted             = var.root_volume_encrypted
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "FQDN" = format("%s%d.%s", local.instance_name, count.index, local.dns_zone_private),
      "Name" = format("%s%d-%s", local.instance_name, count.index, local.vpc_name),
    }
  )

  lifecycle {
    ignore_changes = [ami, key_name, root_block_device, user_data]
  }
}
