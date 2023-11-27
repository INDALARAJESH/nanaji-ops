module "hermosa_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-hybrid?ref=hermosa-ecs-hybrid-v2.1.3"

  env = "dev"
  alb_name_prefix = "on-demand-pub"
  cluster_name_prefix = "ondemand"
  alb_hostnames = ["admin.dev.svpn.chownow.com"]
}
