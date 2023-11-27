{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SQSAccess",
            "Action": [
                "sqs:CreateQueue",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl",
                "sqs:ListQueues",
                "sqs:ReceiveMessage",
                "sqs:SendMessage"
              ],
            "Effect": "Allow",
            "Resource": "arn:aws:sqs:${aws_region}:${aws_account_id}:apple_2fa*"
        },
        {
            "Sid": "ListQueueAccess",
            "Action": [
                "sqs:ListQueues"
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
        }
    ]
}
