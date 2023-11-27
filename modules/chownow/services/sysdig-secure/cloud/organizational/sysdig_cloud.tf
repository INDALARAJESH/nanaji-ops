module "sysdig_cloud_organizational" {
  providers = {
    aws.member = aws.mgmt
  }
  source = "sysdiglabs/secure-for-cloud/aws//examples/organizational"

  sysdig_secure_for_cloud_member_account_id = var.aws_mgmt_account_id
}
