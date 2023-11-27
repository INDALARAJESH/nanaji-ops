module "ops_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/base?ref=cn-ops-base-v3.0.0&depth=1"
  env                 = "ops"
}
