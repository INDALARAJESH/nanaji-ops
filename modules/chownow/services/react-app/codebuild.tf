module "app_codebuild" {
  source                = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/codebuild?ref=codebuild-v2.0.4"
  service               = var.service
  env                   = local.env
  custom_name           = "${var.service}-${local.env}"
  codebuild_description = "${var.service} build and deploy"
  codebuild_image       = var.codebuild_image

  codebuild_artifact_type                   = "S3"
  codebuild_artifact_location               = aws_s3_bucket.app.id
  codebuild_artifact_override_artifact_name = true # needed for react app deployments to use build-YYYMMDDHHSS names
  codebuild_artifact_encryption_disabled    = true # encryption breaks static serving via cloudfront
  codebuild_source                          = "GITHUB"
  codebuild_source_location                 = var.codebuild_source_location
  codebuild_buildspec_path                  = var.codebuild_buildspec_path

  codebuild_environment_variables = concat(
    var.codebuild_environment_variables,
    local.codebuild_environment_variables,
  )
}

# Policy for *this* specfic codebuild
data "aws_iam_policy_document" "app" {
  statement {
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.app.arn,
      "${aws_s3_bucket.app.arn}/*",
    ]
  }

  # Manually configured parameters stored in ssm parameter store (slack webhook)
  statement {
    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*",
    ]
  }

  # Need up update Cloudfront distribution with new build paths
  # Note that the cloudfront:* actions don't accept specific resource arns,
  # only the wildcard
  statement {
    actions = [
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = ["arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:${local.env}/frontend/github*"]
  }
}

resource "aws_iam_role_policy" "addtl" {
  name   = "${var.service}-codebuild-policy-addtl-${local.env}"
  role   = module.app_codebuild.iam_role_id
  policy = data.aws_iam_policy_document.app.json
}
