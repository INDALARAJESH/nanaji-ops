module "kms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/kms?ref=aws-kms-v2.0.0"

  env             = var.env
  env_inst        = var.env_inst
  key_name        = local.app_name
  key_name_prefix = "cn"

  extra_tags = local.extra_tags
}

output "kms_alias_arn" {
  value = module.kms.alias_arn_main
}

output "key_arn_main" {
  value = module.kms.key_arn_main
}
