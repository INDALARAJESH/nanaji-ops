# Create cn-ops-repo bucket for Lambdas
resource "aws_s3_bucket" "cn-repo" {
  bucket = "cn-${var.env}-repo"

  lifecycle {
    ignore_changes = [acl]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "cn-${var.env}-repo",
    )
  )

  grant {
    id          = data.aws_canonical_user_id.current.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
  grant {
    id          = "c427167cc642807eda525bca7a7b526d41d368ea428a46c50ce61377aee42824" # UAT. Added manually at some point
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
}

resource "aws_s3_bucket_policy" "cn-repo" {
  bucket = aws_s3_bucket.cn-repo.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:Get*",
            "Resource": "${aws_s3_bucket.cn-repo.arn}/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "54.183.194.218/32",
                        "52.21.177.104/32",
                        "34.224.187.148/32",
                        "52.207.133.126/32"
                    ]
                }
            }
        },
        {
            "Sid": "AllowVPCEAccess",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:Get*",
            "Resource": "${aws_s3_bucket.cn-repo.arn}/*",
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpce": [
                        "vpce-0fa7a3a0a8c33a8f0",
                        "vpce-0ed37ef6dbfc5e2b3",
                        "vpce-0e43e12bc541721b5",
                        "vpce-0d9e38ca2a1f10735",
                        "vpce-0cd6dad6c496ee175",
                        "vpce-0a8540347bec1c2a7",
                        "vpce-041f52044e87ae13c",
                        "vpce-02862f9532494a31a",
                        "vpce-06ce5dd833c395eb3",
                        "vpce-0d57d3bdb83b0a732",
                        "vpce-04d4461b0d9047c78"
                    ]
                }
            }
        }
    ]
}
POLICY
}
