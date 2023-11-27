variable "associate_public_ip_address" {
  description = "attach a public IP to this instance"
  default     = false
}

variable "instance_count" {
  description = "number of instances to provision"
  default     = 1
}

variable "instance_type" {
  description = "AWS instance size"
  default     = "t3.small"
}

variable "security_group_ids" {
  description = "security groups to assign to instance"
  default     = []
}

variable "custom_instance_name" {
  description = "custom instance name for name tag"
  default     = ""
}
variable "custom_ami_id" {
  description = "Custom AMI ID"
  default     = ""
}

variable "custom_user_data" {
  description = "Custom user data"
  default     = ""
}

variable "custom_iam_instance_profile" {
  description = "Custom IAM instance profile"
  default     = ""
}

variable "custom_key_pair" {
  description = "key pair to use for instance provisioning"
  default     = ""
}

##################
# Disk Variables #
##################

variable "root_volume_encrypted" {
  description = "enable/disable root volume encryption"
  default     = true
}
variable "root_volume_type" {
  description = "The root volume type. Can be gp2 (ssd), gp3 (ssd), io1 (io provisioned), or standard (magnetic)."
  default     = "gp3" # https://aws.amazon.com/about-aws/whats-new/2020/12/introducing-new-amazon-ebs-general-purpose-volumes-gp3/
}

variable "root_volume_size" {
  description = "Size of the root volume, in gigabytes"
  default     = 32
}

variable "storage_delete_on_termination" {
  description = "Should this root block device be removed when terminating the instance?"
  default     = true
}

variable "monitoring" {
  description = "Enabled detailed monitoring"
  default     = true
}

variable "disable_api_termination" {
  default = false
}



locals {
  ami_id               = var.custom_ami_id != "" ? var.custom_ami_id : data.aws_ami.amazon-linux-2.image_id
  user_data            = var.custom_user_data != "" ? var.custom_user_data : data.template_file.user_data.rendered
  instance_name        = var.custom_instance_name != "" ? var.custom_instance_name : var.service
  server_group         = "${local.instance_name}-${local.vpc_name}"
  iam_instance_profile = var.custom_iam_instance_profile != "" ? var.custom_iam_instance_profile : aws_iam_instance_profile.ec2_profile.name
  key_pair             = var.custom_key_pair != "" ? var.custom_key_pair : "ec2-auth-${local.env}"
}
