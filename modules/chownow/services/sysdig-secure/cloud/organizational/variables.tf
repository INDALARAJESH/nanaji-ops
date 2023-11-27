variable "env" {
  description = "unique environment/stage name"
  default     = "" # Short Account Name
}

variable "env_inst" {
  description = "unique environment/stage name"
  default     = ""
}

variable "aws_mgmt_account_id" {
  default = "798805100717"
}

variable "aws_assume_role_name" {
  description = "role assumption for provider settings"
  default     = "OrganizationAccountAccessRole"
}
