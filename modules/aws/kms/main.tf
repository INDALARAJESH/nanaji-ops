# ---------------------------------------------------------------------------------------------------------------------
# KMS CUSTOMER MANAGED KEYS - MAIN
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_kms_key" "key_main" {
  description         = var.key_description
  key_usage           = var.key_usage
  is_enabled          = var.is_enabled
  enable_key_rotation = var.is_rotation_enabled
  policy              = data.aws_iam_policy_document.key_main_key_policy_doc.json

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.key_full_name }
  )
}

data "aws_iam_policy_document" "key_main_key_policy_doc" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Allow access for Key Administrators"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.key_main_master_iam_user.arn]
    }

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Allow use of the key"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        aws_iam_user.key_main_appuser_iam_user.arn,
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Allow attachment of persistent resources"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        aws_iam_user.key_main_appuser_iam_user.arn,
        aws_iam_user.key_main_master_iam_user.arn,
      ]
    }

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.principals) > 0 ? [1] : []

    content {
      sid    = "AllowKMSUsagePrincipal"
      effect = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:CreateGrant",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      dynamic "principals" {
        for_each = var.principals
        content {
          identifiers = principals.value
          type        = principals.key
        }
      }
    }
  }
}

resource "aws_kms_alias" "key_alias_main" {
  name          = "alias/${local.key_full_name}"
  target_key_id = aws_kms_key.key_main.id
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------------------------------------------------------

# Create Customer Master Key ADMIN user
resource "aws_iam_user" "key_main_master_iam_user" {
  name = "kms-master-${var.key_name}-${local.env}"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.key_full_name }
  )
}

resource "aws_iam_access_key" "key_main_master_iam_user" {
  user = aws_iam_user.key_main_master_iam_user.name
}

resource "aws_iam_user_policy_attachment" "key_main_master_iam_user_policy" {
  user       = aws_iam_user.key_main_master_iam_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
}

# Create Customer Master Key APP user
resource "aws_iam_user" "key_main_appuser_iam_user" {
  name = "kms-appuser-${var.key_name}-${local.env}"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.key_full_name }
  )
}

resource "aws_iam_access_key" "key_main_appuser_iam_user" {
  user = aws_iam_user.key_main_appuser_iam_user.name
}

data "aws_iam_policy_document" "key_main_appuser_iam_policy_doc" {
  statement {
    sid = "AllowAppAccessTo${replace(local.key_full_name, "-", "")}"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
    ]

    resources = [
      aws_kms_key.key_main.arn,
    ]
  }
}

resource "aws_iam_policy" "key_main_appuser_iam_policy" {
  name   = "kms-appuser-${var.key_name}-${local.env}"
  policy = data.aws_iam_policy_document.key_main_appuser_iam_policy_doc.json
}

resource "aws_iam_user_policy_attachment" "key_main_appuser_iam_user_policy" {
  user       = aws_iam_user.key_main_appuser_iam_user.name
  policy_arn = aws_iam_policy.key_main_appuser_iam_policy.arn
}
