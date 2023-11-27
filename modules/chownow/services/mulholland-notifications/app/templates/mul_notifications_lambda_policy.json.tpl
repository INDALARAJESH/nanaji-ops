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
            "Resource": "arn:aws:sqs:${aws_region}:${aws_account_id}:mulholland*"
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
            "Sid": "PublishSNS",
            "Action": [
                "sns:*"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:sns:${aws_region}:${aws_account_id}:*"
        },
        {
            "Sid": "GetSecrets",
            "Action": [
                "secretsmanager:GetSecretValue"
                ],
            "Effect": "Allow",
            "Resource": "arn:aws:secretsmanager:${aws_region}:${aws_account_id}:*"
        }
    ]
}
