resource "aws_key_pair" "vm" {
  key_name   = local.name
  public_key = var.public_key

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      "Name" = local.name
    })
  )
}

resource "aws_instance" "bastion" {
  count = var.instance_count

  ami                         = data.aws_ami.amazon-linux-2.image_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  instance_type               = "t3a.small"
  key_name                    = aws_key_pair.vm.id
  subnet_id                   = data.aws_subnets.public.ids[count.index]
  vpc_security_group_ids      = [aws_security_group.vm.id]

  root_block_device {
    delete_on_termination = var.storage_delete_on_termination
    encrypted             = true
    volume_size           = 32
    volume_type           = var.root_volume_type
  }


  user_data = <<-EOT
    #!/bin/bash
    set -e

    echo "Setting hostname"
    hostnamectl set-hostname "bastion${count.index}-${var.service}-${var.vpc_name}"

    echo "Running updates"
    sudo yum -y --disablerepo=* --enablerepo=amzn2-core update

    reboot
  EOT

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      "Name" = "bastion${count.index}-${var.service}-${var.vpc_name}"
    })
  )

  lifecycle {
    ignore_changes = [ami, key_name, root_block_device, user_data]
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion[*].public_ip
}



resource "aws_instance" "internal" {
  count = var.instance_count

  ami                    = data.aws_ami.kali-linux.image_id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  instance_type          = "t3.large"
  key_name               = aws_key_pair.vm.id
  subnet_id              = data.aws_subnets.private.ids[count.index]
  vpc_security_group_ids = concat(var.security_group_ids, [aws_security_group.vm.id])

  root_block_device {
    delete_on_termination = var.storage_delete_on_termination
    encrypted             = true
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e

    echo "Setting hostname"
    hostnamectl set-hostname "internal${count.index}-${var.service}-${var.vpc_name}"

    echo "Resolving hostname resolution problem"
    echo "127.0.0.1 internal${count.index}-${var.service}-${var.vpc_name}" | sudo tee -a /etc/hosts

    echo "Removing MOTD"
    touch /home/kali/.hushlogin

    echo "Running updates"
    sudo apt update
    sudo apt full-upgrade -y


    sudo reboot now
  EOT

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      "Name" = "internal${count.index}-${var.service}-${var.vpc_name}"
    })
  )

  lifecycle {
    ignore_changes = [ami, key_name, root_block_device, user_data]
  }
}

output "internal_private_ip" {
  value = aws_instance.internal[0].private_ip
}
