module "appbuilder_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appbuilder/app?ref=cn-appbuilder-app-v3.0.0"

  env         = "${var.env}"
  custom_name = "mulholland"
}
