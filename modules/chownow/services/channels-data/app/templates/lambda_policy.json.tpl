{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ChannelsDataSecretsManagerAccess",
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
            "Sid": "ChannelsDataS3Access",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${channels_bucket_name}/*",
                "arn:aws:s3:::${nextdoor_bucket_name}/*"
            ]
        }
    ]
}
