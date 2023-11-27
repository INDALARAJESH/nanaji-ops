{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sns:Publish"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:sns:${region}:${account_id}:cn-menu-*",
                "arn:aws:sns:${region}:${account_id}:cn-order-*",
                "arn:aws:sns:${region}:${account_id}:cn-restaurant-*"
            ]
        }
    ]
}
