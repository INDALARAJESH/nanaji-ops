module "appbuilder_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appbuilder/base?ref=cn-appbuilder-base-v3.0.0"

  env = "${var.env}"
}
