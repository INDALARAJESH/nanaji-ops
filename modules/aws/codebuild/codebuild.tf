## Codebuild Project

resource "aws_codebuild_project" "codebuild" {
  name          = local.name
  description   = var.codebuild_description
  build_timeout = var.codebuild_timeout
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    encryption_disabled    = var.codebuild_artifact_encryption_disabled
    type                   = var.codebuild_artifact_type
    location               = var.codebuild_artifact_location
    override_artifact_name = var.codebuild_artifact_override_artifact_name
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = var.codebuild_environment_variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
    privileged_mode = true
  }

  source {
    type                = var.codebuild_source
    location            = var.codebuild_source_location
    buildspec           = var.codebuild_buildspec_path
    report_build_status = true
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${local.name}"
    }
  }
}

## Codebuild Logs

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/aws/codebuild/${local.name}"
  retention_in_days = var.codebuild_log_retention

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}
