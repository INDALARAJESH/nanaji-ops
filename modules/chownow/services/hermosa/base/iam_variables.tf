variable "enable_iam_user" {
  description = "option to create hermosa service user"
  default     = 1
}

locals {
  enable_s3_iam_permissions = var.enable_iam_user == 1 || var.enable_bucket_google_datafeed == 1 || var.enable_bucket_merchant == 1 || var.enable_bucket_onboarding == 1 || var.enable_bucket_static_assets == 1 || var.enable_bucket_facebook == 1 || var.enable_bucket_single_platform == 1 ? 1 : 0
}
