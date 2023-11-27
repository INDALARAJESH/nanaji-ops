variable "env" {
  description = "environment and/or stage for ec2 instance and other resources"
}

variable "env_inst" {
  description = " environment instance name"
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

locals {
  env = "${var.env}${var.env_inst}"

  # key pair name override
  key_pair_name = var.custom_key_pair_name != "" ? var.custom_key_pair_name : "ec2-auth-${local.env}"

  # single-origin, paleo, non-gmo public keys
  module_public_key = fileexists("${path.module}/files/keypair_${var.env}.pub") ? file("${path.module}/files/keypair_${var.env}.pub") : file("${path.module}/files/keypair_default.pub")

  # public key override
  public_key = var.custom_public_key != "" ? var.custom_public_key : local.module_public_key


  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
  }

}
