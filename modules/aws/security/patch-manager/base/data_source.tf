data "aws_caller_identity" "current" {}

data "aws_ssm_patch_baseline" "amazonlinux2" {
  owner            = "AWS"
  name_prefix      = "AWS-AmazonLinux2DefaultPatchBaseline"
  operating_system = "AMAZON_LINUX_2"
}
