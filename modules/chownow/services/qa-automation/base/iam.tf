module "user_svc_qa_automation" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  env         = var.env
  service     = var.service
  user_policy = data.aws_iam_policy_document.svc_qa_automation_policy.json
}

data "aws_iam_policy_document" "svc_qa_automation_policy" {

  statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      "arn:aws:s3:::${local.qa_automation_bucket}",
      "arn:aws:s3:::${local.qa_automation_bucket}/*"
    ]
  }
}

