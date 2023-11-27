module "app" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/app?ref=cn-dms-app-v2.2.7"
  env             = var.env
}
