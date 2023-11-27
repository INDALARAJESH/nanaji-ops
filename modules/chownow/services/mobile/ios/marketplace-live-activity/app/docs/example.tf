module "ios_marketplace_live_activity_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/mobile/ios/marketplace-live-activity/app?ref=cn-ios-marketplace-live-activity-app-v3.0.0"

  env         = var.env
}
