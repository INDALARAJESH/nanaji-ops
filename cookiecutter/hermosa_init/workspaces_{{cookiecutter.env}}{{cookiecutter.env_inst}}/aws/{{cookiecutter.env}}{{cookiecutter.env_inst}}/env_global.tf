variable "env" {
  description = "unique environment/stage name"
  default     = "{{cookiecutter.env}}"
}

variable "env_inst" {
  description = "Environment Instance"
  default     = "{{cookiecutter.env_inst}}"
}

variable "aws_account_id" {
  default = {{cookiecutter.aws_account_id}}
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}
