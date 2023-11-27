module "marketplace_live_activity_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/mobile/ios/marketplace-live-activity/base?ref=cn-ios-marketplace-live-activity-base-v3.0.0"

  env         = var.env
}
