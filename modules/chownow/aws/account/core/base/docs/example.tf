
# Environment without env_inst
# ops>terraform>environments>env>core>base>base.tf`
module "core_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/base?ref=cn-aws-core-base-v2.3.4"

  env                  = var.env
  cidr_block_main      = "10.91.0.0/16"
  enable_vpc_nc        = 0
}

# Environment with `env_inst` variable
# ops>terraform>environments>env>core>base>base.tf`
module "core_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/base?ref=cn-aws-core-base-v2.3.4"

  env                  = var.env
  env_inst             = var.env_inst
  cidr_block_main      = "10.91.0.0/16"
}
