// User Policy for module.user_svc_jenkins

data "aws_iam_policy_document" "jenkins_user" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/svc_jenkins-${local.env}"]
  }

  statement {
    actions = [
      "codebuild:StartBuild",
      "codebuild:ListProjects",
      "codeBuild:BatchGetBuilds",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ecr:BatchGetImage",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecs:DeregisterTaskDefinition",
      "ecs:ListTasks",
      "ecs:RunTask",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "events:ListTargetsByRule",
      "logs:GetLogEvents",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "iam:PassRole",
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

data "aws_iam_policy_document" "jenkins_lambda_deploy" {
  statement {
    actions = [
      "lambda:UpdateFunctionConfiguration",
      "lambda:PublishLayerVersion",
      "lambda:UpdateFunctionCode",
      "lambda:ListLayerVersions",
      "lambda:GetLayerVersion",
      "lambda:PublishVersion",
      "lambda:AddPermission",
      "lambda:GetFunctionConfiguration",
      "lambda:ListFunctions",
    ]

    resources = ["*"]
  }
}

// CloudWatch Events Policies
data "aws_iam_policy_document" "events_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "aws_managed_events_targets_ecs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# channels-data service lambda update
# see: https://github.com/ChowNow/channels-data-service/blob/main/Makefile#L27-L31
data "aws_iam_policy_document" "lambda-deploy-cds" {
  statement {
    actions = [
      "lambda:UpdateFunctionCode"
    ]
    resources = ["arn:aws:lambda:us-east-1::function:channels-data_${local.env}"]
    effect    = "Allow"
  }
}

# Access for the react app lambda to delete artifacts in S3

data "aws_iam_policy_document" "lambda-s3-cleanup-assume-role-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda-s3-cleanup-policy-document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "jenkins-restart-tenable-policy-document" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:tenable-on_lambda_${local.env}_useast1_chownow_com",
      "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:tenable-off_lambda_${local.env}_useast1_chownow_com"
    ]
  }
}
