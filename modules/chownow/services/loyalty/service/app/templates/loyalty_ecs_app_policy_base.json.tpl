{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:Create*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": [
                "${sentry_dsn_arn}*",
                "${launchdarkly_api_key_arn}*",
                "${datadog_ops_api_key_arn}*",
                "${service_api_key_arn}*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": "${dynamodb_table_arn}*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:SendMessage", "sqs:GetQueueUrl"
            ],
            "Resource": "${sqs_queue_arn}"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
              "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        }
    ]
}
