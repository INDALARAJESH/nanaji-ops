{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${bucket_name}/*"
        },
        {
            "Sid": "S3PolicyList",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${bucket_name}"
        }
    ]
}
