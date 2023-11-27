variable "env" {
  default = "ops"
}
variable "env_inst" {
  default = ""
}

variable "ami_id" {
  default = "ami-035be7bafff33b6b6"
}

variable "service" {
  default = "jenkins"
}

variable "tag_managed_by" {
  default = "Terraform"
}

variable "jenkins_ec2_name" {
  default = "jankyns"
}

variable "custom_subnet" { # looking for public_base doesn't work with multiple public subnets
  default = ""
}

variable "instance_type" {
  description = "ec2 instance type"
  default     = "m6i.xlarge"
}

locals {
  region         = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
  subnet         = var.custom_subnet == "" ? "${var.env}0-public" : var.custom_subnet

  common_tags = {
    Environment = var.env
    Service     = var.service
    ManagedBy   = var.tag_managed_by
  }
}
