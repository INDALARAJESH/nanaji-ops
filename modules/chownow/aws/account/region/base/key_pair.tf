module "key_pair" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/key-pair/basic?ref=aws-key-pair-basic-v2.0.0"

  count = var.enable_key_pair

  env      = var.env
  env_inst = var.env_inst

  extra_tags = local.extra_tags

}
