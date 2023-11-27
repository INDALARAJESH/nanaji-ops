resource "aws_sns_platform_application" "sns_platform_app" {
  name                     = local.platform_app_name
  platform                 = local.platform
  platform_credential      = var.platform_credential
  platform_principal       = var.platform_principal
  apple_platform_team_id   = var.apple_platform_team_id
  apple_platform_bundle_id = var.apple_platform_bundle_id
}
