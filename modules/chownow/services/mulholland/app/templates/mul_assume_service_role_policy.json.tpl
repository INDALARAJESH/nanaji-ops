{
    "Version": "2012-10-17",
    "Statement": [
    {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::${aws_account_id}:role/mulholland-on-prem-${env}"
  },
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
    },
    {
    "Sid": "STSAccessToken",
    "Action": [
        "sts:GetFederationToken"
        ],
    "Effect": "Allow",
    "Resource": "*"
    }
  ]
}
