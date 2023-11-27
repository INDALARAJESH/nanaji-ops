module "kms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/kms?ref=aws-kms-v2.0.0"
  count  = var.enable_kms_key

  env             = var.env
  env_inst        = var.env_inst
  key_name        = "main"
  key_name_prefix = "cn"

  extra_tags = local.extra_tags
}
