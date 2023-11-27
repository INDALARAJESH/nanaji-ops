{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:DescribeRepositories",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage",
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:CreateLogStream"
            ],
            "Resource": [
                "arn:aws:ecr:${aws_region}:${aws_account_id}:repository/${repository}/*",
                "arn:aws:ecr:${aws_region}:${aws_account_id}:repository/${repository}",
                "arn:aws:codebuild:${aws_region}:${aws_account_id}:build/*",
                "arn:aws:logs:${aws_region}:${aws_account_id}:log-group:/aws/codebuild/*",
                "arn:aws:logs:${aws_region}:${aws_account_id}:log-group:${service}-log-group-${environment}/*",
                "arn:aws:iam::${aws_account_id}:role/${environment}/*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ecr:GetAuthorizationToken",
                "ecs:CreateTaskSet",
                "ecs:DeleteTaskSet",
                "ecs:DescribeClusters",
                "ecs:DescribeServices",
                "ecs:DescribeTasks",
                "ecs:DescribeTaskDefinition",
                "ecs:DeregisterTaskDefinition",
                "ecs:ListServices",
                "ecs:ListTasks",
                "ecs:ListTaskDefinitions",
                "ecs:ListTaskDefinitionFamilies",
                "ecs:ListClusters",
                "ecs:RegisterTaskDefinition",
                "ecs:RunTask",
                "ecs:StartTask",
                "ecs:StopTask",
                "ecs:UpdateService",
                "ecs:UpdateTaskSet",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowSecretsReadCodebuildReadable",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:${aws_region}:${aws_account_id}:secret:*",
            "Condition": {
                "StringEquals": {"secretsmanager:ResourceTag/CodebuildReadable": "true"}
            }
        }
    ]
}
