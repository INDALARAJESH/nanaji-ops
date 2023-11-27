data "aws_iam_policy_document" "ec2_reboot" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:StartInstances",
      "ec2:StopInstances",
    ]
    resources = ["*"]
  }

}


module "user_svc_ec2_reboot" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_user_ec2_reboot

  env         = var.env
  env_inst    = var.env_inst
  service     = var.service
  user_policy = data.aws_iam_policy_document.ec2_reboot.json
}
