provider "aws" {
  alias = "delegate"
  assume_role {
    role_arn     = "arn:aws:iam::${var.delegate_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}
