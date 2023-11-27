{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:ListBucket"
            ],
          "Resource": [
            "arn:aws:s3:::${artifact_bucket_name}/*",
            "arn:aws:s3:::${artifact_bucket_name}"
            ]
        }
    ]
}
