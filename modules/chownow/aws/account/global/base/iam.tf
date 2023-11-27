module "user_svc_jenkins" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.2"

  count = var.enable_user_jenkins

  custom_path = "/"
  env         = var.env
  env_inst    = var.env_inst
  service     = "jenkins"
  user_policy = data.aws_iam_policy_document.jenkins_user.json
}

data "aws_iam_policy_document" "svc_jenkins_assume" {
  count = var.enable_user_jenkins
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/svc_jenkins-${local.env}"]
    }
  }
}

resource "aws_iam_role" "svc_jenkins" {
  count              = var.enable_user_jenkins
  name               = "svc_jenkins-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.svc_jenkins_assume[count.index].json
  managed_policy_arns = [
    aws_iam_policy.jenkins_warehouse.arn,
    aws_iam_policy.jenkins_codebuild.arn,
    aws_iam_policy.jenkins_ecs_deploy_tool.arn,
    aws_iam_policy.jenkins_ecs.arn,
    aws_iam_policy.jenkins_env_secrets.arn,
    aws_iam_policy.jenkins_cds_deploy.arn,
    aws_iam_policy.jenkins_ecr_ops_read_access_policy.arn
  ]
}

resource "aws_iam_policy" "jenkins_lambda_deploy" {
  name        = "jenkins-lambda-deploy-${local.env}"
  description = "Lambda deploy permissions for Jenkins user"
  policy      = data.aws_iam_policy_document.jenkins_lambda_deploy.json
}

resource "aws_iam_user_policy_attachment" "jenkins_lambda_deploy" {
  count      = var.enable_user_jenkins
  user       = "svc_jenkins-${local.env}"
  policy_arn = aws_iam_policy.jenkins_lambda_deploy.arn
}

resource "aws_iam_policy" "jenkins_warehouse" {
  name = "warehouse-put-events-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "events:PutEvents"
        ],
        "Resource" : [
          "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_codebuild" {
  name = "codebuild-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:GetLogEvents",
          "codebuild:StartBuild",
          "codebuild:ListProjects",
          "codeBuild:BatchGetBuilds"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_ecs_deploy_tool" {
  name = "ecs-deploy-tool-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:ListImages",
          "ecs:DeregisterTaskDefinition",
          "ecs:ListTasks",
          "ecs:RegisterTaskDefinition",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "events:ListTargetsByRule"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
        ],
        "Resource" : [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_ecs" {
  name = "ecs-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecs:DescribeTaskDefinition"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "ecs:DescribeServices",
          "ecs:UpdateService",
        ],
        "Resource" : [
          "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_env_secrets" {
  name = "env-secrets-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:List*",
          "secretsmanager:Put*",
          "secretsmanager:Describe*"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_cds_deploy" {
  name = "cds-lambda-deploy-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:UpdateFunctionCode"
        ],
        "Resource" : [
          "arn:aws:lambda:us-east-1::function:channels-data_${local.env}"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_ecr_ops_read_access_policy" {
  name = "ecr-ops-read-access-${local.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:DescribeImageScanFindings"
        ],
        "Resource" : [
          "arn:aws:ecr:us-east-1:449190145484:repository/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_restart_tenable" {
  count       = var.enable_user_jenkins
  name        = "jenkins_restart_tenable_lambda_${local.env}"
  description = "Allows Jenkins to trigger Tenable EC2 restart Lambdas"
  policy      = data.aws_iam_policy_document.jenkins-restart-tenable-policy-document.json
}

module "user_svc_grafana" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_user_grafana

  env         = var.env
  env_inst    = var.env_inst
  service     = "grafana"
  user_policy = file("${path.module}/templates/grafana_iam_user_policy.json.tpl")
}

# # Github Actions user with the ability to perform tasks in ECR
module "user_svc_gha_ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_user_gha_ecr

  env         = var.env
  env_inst    = var.env_inst
  service     = "github_action_ecr"
  user_policy = file("${path.module}/templates/gha_ecr_iam_user_policy.json.tpl")
}

module "user_svc_hermosa_sns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_user_hermosa_sns

  env      = var.env
  env_inst = var.env_inst
  service  = "hermosa_sns"
  user_policy = templatefile(
    "${path.module}/templates/hermosa_sns_iam_user_policy.json.tpl",
    { region = data.aws_region.current.name, account_id = data.aws_caller_identity.current.account_id }
  )
}

# SDET User to run tests against AWS Infrastucture

module "user_svc_sdet" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v2.0.0"

  count = var.enable_user_sdet

  env      = var.env
  env_inst = var.env_inst
  service  = "sdet"
  user_policy = templatefile(
    "${path.module}/templates/sdet_iam_user_policy.json.tpl",
    { region = data.aws_region.current.name, account_id = data.aws_caller_identity.current.account_id }
  )
}


# Role allowing AWS Events to invoke ECS commands

resource "aws_iam_role" "cloudwatch_events_ecs" {
  name        = "cloudwatch-events-ecs-${local.env}"
  description = "Role allowing CloudWatch Events rules/targets to invoke ECS tasks"

  assume_role_policy = data.aws_iam_policy_document.events_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_events_target_ecs" {
  role       = aws_iam_role.cloudwatch_events_ecs.id
  policy_arn = data.aws_iam_policy.aws_managed_events_targets_ecs.arn
}


### AWS DMS IAM role to enable cloudwatch logs
module "aws_dms_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dms/iam?ref=aws-dms-iam-v2.0.0"

  count = var.enable_dms_iam

  env      = var.env
  env_inst = var.env_inst

}

module "packer_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/packer/iam?ref=aws-packer-iam-v2.0.0"

  count = var.enable_packer_iam

  env      = var.env
  env_inst = var.env_inst

}

module "terraform_developer_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/terraform-developer/iam?ref=aws-terraform-developer-iam-v2.0.1"

  count = var.enable_terraform_developer_iam

  env      = var.env
  env_inst = var.env_inst
}


### Role allow react apps lambda function to delete older artifact builds on S3
resource "aws_iam_role" "lambda-s3-cleanup" {
  name               = "lambda-s3-cleanup-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.lambda-s3-cleanup-assume-role-document.json

  tags = {
    Name        = "s3 cleanup"
    Environment = local.env
    App         = "s3 cleanup"
  }
}

resource "aws_iam_policy" "lambda-s3-cleanup-policy" {
  name   = "lambda-s3-cleanup-policy-${local.env}"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda-s3-cleanup-policy-document.json
}

resource "aws_iam_role_policy_attachment" "lambda-s3-cleanup-policy-attachment" {
  role       = aws_iam_role.lambda-s3-cleanup.name
  policy_arn = aws_iam_policy.lambda-s3-cleanup-policy.arn
}


# OIDC and Basic Teleport User
resource "aws_iam_user" "teleport" {
  count = var.enable_teleport_iam

  name = "teleport"
}
resource "random_string" "teleport_thumbprint" {
  count = var.enable_teleport_iam

  length  = 40
  special = false
  upper   = true
}

resource "aws_iam_openid_connect_provider" "teleport_oidc" {
  count = var.enable_teleport_iam

  url = "https://chownow.teleport.sh"
  client_id_list = [
    "discover.teleport"
  ]

  thumbprint_list = [
    random_string.teleport_thumbprint[count.index].id # Placeholder thumbprint
  ]

  lifecycle {
    # Ignore any changes to OIDC Thumbprint, unless rotating
    ignore_changes = [
      thumbprint_list
    ]
  }
}

resource "aws_iam_role" "teleport_oidc" {
  count = var.enable_teleport_iam

  name = "teleport-${var.env}"
  path = "/ec2_roles/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/chownow.teleport.sh"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "chownow.teleport.sh:aud" : "discover.teleport"
          }
        }
      }
    ]
  })
}

# Dynamic Database Search Policy
resource "aws_iam_policy" "teleport_dynamic" {
  count = var.enable_teleport_iam


  name = "teleport-dynamic-${var.env}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBInstances",
                "rds:DescribeDBClusters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticache:ListTagsForResource",
                "elasticache:DescribeReplicationGroups",
                "elasticache:DescribeCacheClusters",
                "elasticache:DescribeCacheSubnetGroups",
                "elasticache:DescribeUsers",
                "elasticache:ModifyUser"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:CreateSecret",
                "secretsmanager:UpdateSecret",
                "secretsmanager:DeleteSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:PutSecretValue",
                "secretsmanager:TagResource"
            ],
            "Resource": "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:teleport/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "teleport_dynamic" {
  count = var.enable_teleport_iam

  role       = aws_iam_role.teleport_oidc[count.index].name
  policy_arn = aws_iam_policy.teleport_dynamic[count.index].arn
}

# Teleport User Connect Policy
resource "aws_iam_policy" "teleport_connect" {
  count = var.enable_teleport_iam

  name = "teleport-connect-${var.env}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rds-db:connect",
      "Resource": "arn:aws:rds-db:us-east-1:${data.aws_caller_identity.current.account_id}:dbuser:*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "teleport_connect" {
  count = var.enable_teleport_iam

  user       = aws_iam_user.teleport[count.index].name
  policy_arn = aws_iam_policy.teleport_connect[count.index].arn
}

resource "aws_iam_user_policy_attachment" "jenkins_restart_tenable" {
  count      = var.enable_user_jenkins
  user       = "svc_jenkins-${local.env}"
  policy_arn = aws_iam_policy.jenkins_restart_tenable[count.index].arn
}
