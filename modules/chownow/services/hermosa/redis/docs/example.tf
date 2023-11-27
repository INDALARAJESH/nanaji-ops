module "redis" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/redis?ref=cn-hermosa-redis-v2.0.5"
  env    = "uat"
}
