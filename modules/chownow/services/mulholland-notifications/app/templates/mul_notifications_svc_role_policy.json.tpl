{
    "Version": "2012-10-17",
    "Statement": [
  {
    "Sid": "AccessECR",
    "Action": [
        "ecr:*"
        ],
    "Effect": "Allow",
    "Resource": "*"
    },
    {
    "Sid": "AccessSecretsManager",
    "Action": [
        "secretsmanager:*"
        ],
    "Effect": "Allow",
    "Resource": "*"
    }
  ]
}
