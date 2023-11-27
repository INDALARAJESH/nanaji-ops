variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "unique service name for project/application"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "name_prefix" {
  default = "cn"
}

variable "web_acl_id" {
  description = <<EOT
      A unique identifier that specifies the AWS WAF web ACL.
      To specify a web ACL created using the latest version of AWS WAF (WAFv2) use the ACL ARN.
      To specify a web ACL created using AWS WAF Classic, use the ACL ID.
      EOT
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}
locals {
  env = "${var.env}${var.env_inst}"

  common_tags = { "Environment" = local.env
    "EnvironmentInstance" = var.env_inst
    "ManagedBy"           = var.tag_managed_by
    "Service"             = var.service
  "TFModule" = "modules/aws/cloudfront/distribution" }
}
