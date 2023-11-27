locals {
  appsmithrwpwd = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["password"]
}


module "secret_name_appsmithrw" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "mongodb-${var.service} ${var.env} appsmithrw user password"
  env         = var.env
  secret_name = "mongodb-${var.service}-${var.env}-appsmithrw-user-pwd"
  secret_key  = "password"
  service     = var.service
}

module "secret_name_appsmithadmin" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "mongodb-${var.service} ${var.env} appsmithadmin user password"
  env         = var.env
  secret_name = "mongodb-${var.service}-${var.env}-appsmithadmin-user-pwd"
  secret_key  = "password"
  service     = var.service
}

module "secret_name_appsmithmongodbURI" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  is_kv              = true
  secret_description = "mongodb-${var.service} ${var.env} appsmithrw MongoDB URI"
  secret_name        = "mongodb-${var.service}-${var.env}-appsmithrw-mongodbURI"
  secret_kv          = map("APPSMITH_MONGODB_URI", "mongodb://appsmithrw:${local.appsmithrwpwd}@mongodb-appsmith0.dev.aws.chownow.com/appsmithdb")
  service            = var.service
}


resource "aws_iam_instance_profile" "iam_profile" {
  name = "mongodb-${var.service}-${var.env}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "mongodb-${var.service}-${var.env}-role"
  path                = "/"
  managed_policy_arns = [aws_iam_policy.policy.arn, "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    sid = "1"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      module.secret_name_appsmithrw.secret_arn,
      module.secret_name_appsmithadmin.secret_arn,
      module.secret_name_appsmithmongodbURI.secret_arn
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "mongodb-${var.service}-${var.env}-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_document.json
}


resource "random_string" "mongo_key" {
  length  = 8
  special = false
}
