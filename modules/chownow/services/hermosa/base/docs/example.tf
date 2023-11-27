module "hermosa_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/base?ref=cn-hermosa-base-v2.3.5"

  env                 = "uat"
  isolated_useragents = ["cloudkitchens", "CubohBot/*", "OrderRobot/*" ]
}

# Terraform (alternate):
module "hermosa_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/base?ref=cn-hermosa-base-v2.3.5"

  env                 = "uat"
  isolated_useragents = ["cloudkitchens", "CubohBot/*", "OrderRobot/*"]

  # Disable web ALB
  enable_alb_web = 0

  # Disable hermosa buckets
  enable_bucket_facebook        = 0
  enable_bucket_google_datafeed = 0
  enable_bucket_merchant        = 0
  enable_bucket_onboarding      = 0
  enable_bucket_single_platform = 0
  enable_bucket_static_assets   = 0
}
