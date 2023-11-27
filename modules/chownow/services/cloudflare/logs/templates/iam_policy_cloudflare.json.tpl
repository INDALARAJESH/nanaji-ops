{
  "Id": "Policy1506627184792",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudFlarePushLogs",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${s3_bucket}/*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${aws_account_number}:user/${aws_user}"
        ]
      }
    }
  ]
}
