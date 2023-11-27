module "backup" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/backup?ref=aws-backup-v2.0.0"

  backup_arn     = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:volume/${lookup(module.jenkins_ec2.volume_ids.0[0], "volume_id")}"]
  env            = var.env
  env_inst       = var.env_inst
  lifecycle_days = var.lifecycle_days
  schedule       = var.schedule
  service        = var.service
}
