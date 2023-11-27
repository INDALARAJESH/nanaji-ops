{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SQSAccess",
            "Action": [
                "sqs:*"
              ],
            "Effect": "Allow",
            "Resource": "arn:aws:sqs:${aws_region}:${aws_account_id}:*"
        },
        {
            "Sid": "AccountTableAccess",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:ListTables",
                "dynamodb:PutItem",
                "dynamodb:Query"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:${aws_region}:${aws_account_id}:table/${account_table_name}"
        },
        {
            "Sid": "ListTableAccess",
            "Action": [
                "dynamodb:ListTables"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:${aws_region}:${aws_account_id}:*"
        },
        {
            "Sid": "PublishSNS",
            "Action": [
                "sns:*"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:sns:${aws_region}:${aws_account_id}:*"
        },
        {
            "Sid": "AccessS3",
            "Action": [
                "s3:*"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Sid": "AccessECR",
            "Action": [
                "ecr:*"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:ecr:${aws_region}:${aws_account_id}:*"
        }
    ]
}
