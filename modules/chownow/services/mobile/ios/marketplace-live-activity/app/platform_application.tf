module "ios_marketplace_live_activity" {
  source                   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/platform-application?ref=aws-sns-platform-app-v3.0.0"
  app_name                 = var.platform_app_name
  env                      = local.env
  platform                 = local.platform
  platform_credential      = local.apns_signing_key    ### APNS SIGNING KEY
  platform_principal       = local.apns_signing_key_id ### APNS SIGNING KEY ID
  apple_platform_team_id   = var.apple_team_id
  apple_platform_bundle_id = var.apple_bundle_id
}
