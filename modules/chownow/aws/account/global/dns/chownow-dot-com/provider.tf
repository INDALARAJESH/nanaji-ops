provider "aws" {
  alias  = "delegate_uat"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::851526424910:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias  = "delegate_stg"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::937307470951:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias  = "delegate_sandbox"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::816344209152:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }
}
