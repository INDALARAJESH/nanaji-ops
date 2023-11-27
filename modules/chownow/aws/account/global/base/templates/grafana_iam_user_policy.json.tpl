{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "sqs:ListQueues",
                "sqs:GetQueueAttributes",
                "sns:List*",
                "sns:Get*",
                "rds:DescribeDBInstances",
                "elasticloadbalancing:Describe*",
                "elasticache:DescribeCacheClusters",
                "ec2:ReportInstanceStatus",
                "ec2:Get*",
                "ec2:Describe*",
                "cloudwatch:List*",
                "cloudwatch:Get*",
                "cloudwatch:Describe*",
                "autoscaling:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingLogsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        }
    ]
}
