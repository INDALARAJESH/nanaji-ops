
variable "env" {
  description = "environment and/or stage for ec2 instance and other resources"
}

variable "env_inst" {
  description = "environment instance name"
  default     = ""
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "key_name" {
  description = "Key name"
}

variable "key_name_prefix" {
  description = "Key name prefix"
  default     = ""
}

variable "key_description" {
  description = "Key description"
  default     = ""
}

variable "key_usage" {
  description = "Usage"
  default     = "ENCRYPT_DECRYPT"
}

variable "is_enabled" {
  description = "Key enabled?"
  default     = true
}

variable "is_rotation_enabled" {
  description = "Key rotation enabled?"
  default     = false
}

variable "principals" {
  description = "Principal to allow to use the key for encryption/decryption. ie { Service = [\"logs.us-east-1.amazonaws.com\"] }"
  default     = {}
}

locals {
  env = "${var.env}${var.env_inst}"
  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

  key_full_name = "${var.key_name_prefix}-${var.key_name}-cmk-${local.env}-${data.aws_region.current.name}"
}
