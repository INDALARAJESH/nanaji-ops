resource "aws_kms_key" "pos_toast_token_encryption" {
  description = "KMS key used for encrypting daily toast access tokens"
}

resource "aws_kms_alias" "pos_toast" {
  name          = "alias/pos-toast-kms"
  target_key_id = aws_kms_key.pos_toast_token_encryption.id
}

output "key_arn_main" {
  value = aws_kms_key.pos_toast_token_encryption.arn
}

output "kms_alias_arn" {
  value = aws_kms_alias.pos_toast.arn
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:DescribeKey"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/${local.service}*"]
    }

    resources = [
      "*"
    ]

    condition {
      test     = "StringLike"
      variable = "kms:RequestAlias"

      values = [
        aws_kms_alias.pos_toast.name
      ]
    }
  }
}
