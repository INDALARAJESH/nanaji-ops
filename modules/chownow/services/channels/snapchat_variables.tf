variable "enable_snapchat" {
  description = "boolean toggle to create snapchat resources"
  default     = true
}

variable "snapchat_iam_assumerole_arn" {
  # This is Snap's production IAM role ARN
  description = "Snapchat AWS IAM AssumeRole ARN"
  default     = "arn:aws:iam::949490519709:role/snap-chownow-role"
}

variable "snapchat_is_test_env" {
  description = "boolean toggle to create aws resources for testing purposes"
  default     = false
}

locals {
  assumerole_arn = var.snapchat_is_test_env && var.enable_snapchat ? aws_iam_role.cn_snapchat_assumerole[0].arn : var.snapchat_iam_assumerole_arn
}
