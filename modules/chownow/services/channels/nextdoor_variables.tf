variable "enable_nextdoor" {
  description = "boolean toggle to create nextdoor resources"
  default     = true
}

variable "nextdoor_s3_bucket_name" {
  description = "name of S3 bucket for Nextdoor channel partner (requested that it include ChowNow in the name)"
  default     = ""
}

variable "nextdoor_aws_account_ids" {
  description = "AWS account IDs that will have access to Nextdoor s3 bucket"
  default     = []
  type        = list(string)
}

locals {
  nextdoor_s3_bucket_name  = var.nextdoor_s3_bucket_name == "" ? "chownow-${var.service}-nextdoor-${local.env}" : var.nextdoor_s3_bucket_name
  nextdoor_aws_account_ids = concat(list(data.aws_caller_identity.current.account_id), var.nextdoor_aws_account_ids)
}
