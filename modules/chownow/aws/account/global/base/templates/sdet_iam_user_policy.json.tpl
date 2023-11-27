{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sns:Publish",
                "sqs:Write"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:sns:${region}:${account_id}:cn-restaurant-events-*",
                "arn:aws:sqs:${region}:${account_id}:restaurant-search-etl-kickoff_*"
            ]
        },
        {
            "Action": [
                "rds:Describe*",
                "rds:List*",
                "elasticache:Describe*",
                "ssm:StartSession",
                "ssm:TerminateSession",
                "ssm:ResumeSession",
                "ec2:Describe*"
            ],
            "Effect": "Allow",
            "Resource": ["*"]
        }
    ]
}
