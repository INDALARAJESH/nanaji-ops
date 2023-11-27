variable "service" {
  description = "unique service name for project/application"
  default     = "ec2-reboot"
}

variable "env" {
  description = "environment and/or stage for ec2 instance and other resources"
  type        = string
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "enable_user_ec2_reboot" {
  description = "enables/disables ec2_reboot user creation"
  default     = 1
}
