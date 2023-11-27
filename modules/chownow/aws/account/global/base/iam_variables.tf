#########
# Users #
#########
variable "enable_user_jenkins" {
  description = "on/off toggle for jenkins user creation"
  default     = 1
}

variable "enable_user_grafana" {
  description = "on/off toggle for grafana user creation"
  default     = 1
}

variable "enable_user_gha_ecr" {
  description = "on/off toggle for gha_ecr user creation"
  default     = 1
}

variable "enable_user_hermosa_sns" {
  description = "on/off toggle for hermosa_sns user creation"
  default     = 0
}

variable "enable_user_sdet" {
  description = "on/off toggle for SDET IAM user creation"
  default     = 0
}

###########
# AWS DMS #
###########

variable "enable_dms_iam" {
  description = "on/off toggle for AWS DMS IAM role creation"
  default     = 1
}

###########
#  Packer #
###########

variable "enable_packer_iam" {
  description = "on/off toggle for Packer IAM role creation"
  default     = 1
}

########################
#  Terraform developer #
########################

variable "enable_terraform_developer_iam" {
  description = "on/off toggle for terraform_developer role creation"
  default     = 0
}

########################
#  Teleport OIDC/User  #
########################

variable "enable_teleport_iam" {
  description = "on/off toggle for teleport OIDC/User creation, This is generally turned off for env_inst environments"
  default     = 0
}
