variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
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
  env            = "${var.env}${var.env_inst}"
  s3_bucket_name = "cn-backup-${local.env}"


  env_inst_tag = var.env_inst == "" ? {} : map("EnvironmentInstance", var.env_inst, )
  common_tags = merge({
    Environment = local.env
    ManagedBy   = var.tag_managed_by
    TFModule    = "ops-tf-modules/modules/chownow/services/ops/tools/backup/db"
  }, local.env_inst_tag)


}
