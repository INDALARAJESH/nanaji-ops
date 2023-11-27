provider "aws" {
  alias  = "delegate_prod"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::234359455876:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}
