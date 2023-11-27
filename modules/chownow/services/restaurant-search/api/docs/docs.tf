locals {
  bucket_name = "${var.service}-static"
}

module "docs_s3_bucket" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  acl           = "public-read"
  bucket_name   = local.bucket_name
  env           = var.env
  env_inst      = var.env_inst
  force_destroy = false
  service       = var.service

  website = {
    index_document = "index.html"
    routing_rules  = <<EOF
          [{
              "Condition": {
                  "HttpErrorCodeReturnedEquals": "404"
              },
              "Redirect": {
                  "ReplaceKeyWith": "docs"
              }
          }]
          EOF
  }

  attach_public_policy = false
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${local.bucket_name}/*"
      },
      {
        "Sid" : "SourceIp",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : "arn:aws:s3:::${local.bucket_name}/*",
        "Condition" : {
          "NotIpAddress" : {
            "aws:SourceIp" : var.vpn_ip_addresses
          }
        },
        "Principal" : {
          "AWS" : "*"
        }
      }
    ]
  })

}
