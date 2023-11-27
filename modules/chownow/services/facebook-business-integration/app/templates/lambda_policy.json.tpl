{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "secret",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "arn:aws:secretsmanager:${aws_region}:${aws_account_id}:secret:${secrets_path}",
                "${dd_api_key_arn}*"
            ]
        },
        {
            "Sid": "DynamoDB",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": [
                "arn:aws:dynamodb:${aws_region}:${aws_account_id}:table/${table_name}",
                "arn:aws:dynamodb:${aws_region}:${aws_account_id}:table/${table_name}/index/*"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "KMS",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": [
                "${kms_arn}"
            ]
        }
    ]
}
