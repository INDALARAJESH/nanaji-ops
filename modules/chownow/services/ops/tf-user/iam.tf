################################
# Production Terraform Account #
################################

resource "aws_iam_user" "terraform_production" {
  name = local.username_production
  path = local.path

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.username_production,
    )
  )
}

data "aws_iam_policy_document" "terraform_production" {
  statement {
    sid    = "AssumeRoleToProduction"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::234359455876:role/OrganizationAccountAccessRole", # production/pci AWS account
      "arn:aws:iam::595631937550:role/OrganizationAccountAccessRole"  # non-cardholder production/ncp AWS account
    ]
  }
  statement {
    sid    = "RWS3TerraformStateProduction"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::chownow-terraform-remote-state-v4-prod*",
      "arn:aws:s3:::chownow-terraform-remote-state-v4-prod/*"
    ]
  }
  statement {
    sid    = "ROS3TerraformStateOps"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::chownow-terraform-remote-state-v4-ops*",
      "arn:aws:s3:::chownow-terraform-remote-state-v4-ops/*"
    ]
  }
}

resource "aws_iam_user_policy" "terraform_production" {

  name   = local.username_production
  policy = data.aws_iam_policy_document.terraform_production.json
  user   = aws_iam_user.terraform_production.name

}
