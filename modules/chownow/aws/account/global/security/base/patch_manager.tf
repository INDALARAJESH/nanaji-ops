module "patch_manager" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security/patch-manager/base?ref=aws-security-patch-manager-base-v2.0.1"

  env = local.env

  environment_tag_list         = var.environment_tag_list
  patch_manager_scan_schedule  = var.patch_manager_scan_schedule
  patch_manager_patch_schedule = var.patch_manager_patch_schedule
}
