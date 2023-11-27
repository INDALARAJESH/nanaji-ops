variable "bucket_name_prefix" {
  description = "s3 bucket name prefix"
  default     = "cn-"
}

variable "enable_bucket_facebook" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_google_datafeed" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_merchant" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_onboarding" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_single_platform" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_static_assets" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_audit" {
  description = "enable/disable bucket creation"
  default     = 1
}

variable "enable_bucket_menu" {
  description = "enable/disable menu s3 bucket lookup"
  default     = 0
}

variable "audit_bucket_name" {
  description = "Custom name for audit archive bucket"
  default     = ""
}

variable "menu_bucket_name" {
  description = "Name of the Menu S3 bucket"
  default     = ""
}

variable "facebook_bucket_name" {
  description = "Custom name for the facebook bucket"
  default     = ""
}

variable "google_datafeed_bucket_name" {
  description = "Name of the google datafeed bucket"
  default     = ""
}

variable "merchant_bucket_name" {
  description = "Custom name for merchant bucket"
  default     = ""
}

variable "onboarding_bucket_name" {
  description = "Name of the onboarding S3 bucket"
  default     = ""
}

variable "single_platform_bucket_name" {
  description = "Custom name for single platform bucket"
  default     = ""
}

variable "static_assets_bucket_name" {
  description = "Name of the static assets S3 bucket"
  default     = ""
}

locals {
  bucket_facebook        = var.facebook_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-facebook-${local.env}" : var.facebook_bucket_name
  bucket_google_datafeed = var.google_datafeed_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-google-datafeed-${local.env}" : var.google_datafeed_bucket_name
  bucket_merchant        = var.merchant_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-merchant-${local.env}" : var.merchant_bucket_name
  bucket_onboarding      = var.onboarding_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-onboarding-${local.env}" : var.onboarding_bucket_name
  bucket_single_platform = var.single_platform_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-singleplatform-${local.env}" : var.single_platform_bucket_name
  bucket_static_assets   = var.static_assets_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-static-assets-${local.env}" : var.static_assets_bucket_name
  bucket_audit           = var.audit_bucket_name == "" ? "${var.bucket_name_prefix}${var.service}-audit-${local.env}" : var.audit_bucket_name
  bucket_menu            = var.menu_bucket_name == "" ? "menu-rds-data-migration-${local.env}" : var.menu_bucket_name
}
