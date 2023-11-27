{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account}:root"
            },
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:GetObjectVersion",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${bucket_name}",
                "arn:aws:s3:::${bucket_name}/*"
            ]
        }
    ]
}
