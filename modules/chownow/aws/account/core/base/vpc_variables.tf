######################
# Main VPC Variables #
######################
variable "enable_vpc_main" {
  description = "enable/disable main vpc creation"
  default     = 1
}

variable "cidr_block_main" {
  description = "the Main VPC's CIDR Block"
  default     = ""
}

variable "extra_allowed_subnets_main" {
  description = "extra subnets to allow access to VPC"
  default     = []
}

variable "private_subnets_main" {
  description = "The Main VPC's private subnets"
  default     = []
}

variable "privatelink_subnets_main" {
  description = "The Main VPC's privatelink subnets"
  default     = []
}

variable "public_subnets_main" {
  description = "The Main VPC's public subnets"
  default     = []
}

variable "vpc_name_prefix_main" {
  description = "The Main VPC's name prefix, eg. main in main-dev"
  default     = "main"
}

################################
# Non-Cardholder VPC Variables #
################################
variable "enable_vpc_nc" {
  description = "enable/disable non-cardholder data VPC creation"
  default     = 1
}

variable "cidr_block_nc" {
  description = "the non-cardholder data VPC's CIDR Block"
  default     = ""
}

variable "extra_allowed_subnets_nc" {
  description = "extra subnets to allow access to VPC"
  default     = []
}

variable "private_subnets_nc" {
  description = "The non-cardholder data VPC's private subnets"
  default     = []
}

variable "privatelink_subnets_nc" {
  description = "The non-cardholder data VPC's privatelink subnets"
  default     = []
}

variable "public_subnets_nc" {
  description = "The non-cardholder data VPC's public subnets"
  default     = []
}

variable "vpc_name_prefix_nc" {
  description = "The non-cardholder data VPC's name prefix, eg. nc in nc-dev"
  default     = "nc"
}

#############################
# Pritunl VPN VPC Variables #
#############################
variable "enable_vpc_pritunl" {
  description = "enable/disable Pritunl VPN VPC creation"
  default     = 0
}

variable "cidr_block_pritunl" {
  description = "The Pritunl VPN VPC's CIDR Block"
  default     = ""
}

variable "extra_allowed_subnets_pritunl" {
  description = "Extra subnets to allow access to VPC"
  default     = []
}

variable "private_subnets_pritunl" {
  description = "The Main VPC's private subnets"
  default     = []
}

variable "privatelink_subnets_pritunl" {
  description = "The Main VPC's privatelink subnets"
  default     = []
}

variable "public_subnets_pritunl" {
  description = "The Pritunl VPN VPC's public subnets"
  default     = []
}

variable "vpc_name_prefix_pritunl" {
  description = "The Pritunl VPN VPC's name prefix, eg. pritunl in pritunl-dev"
  default     = "pritunl"
}

######################
# Env VPC Variables #
######################
variable "enable_vpc_env" {
  description = "enable/disable env vpc creation"
  default     = 0
}

variable "cidr_block_env" {
  description = "the env VPC's CIDR Block"
  default     = ""
}

variable "extra_allowed_subnets_env" {
  description = "extra subnets to allow access to VPC"
  default     = []
}

variable "private_subnets_env" {
  description = "The env VPC's private subnets"
  default     = []
}

variable "public_subnets_env" {
  description = "The env VPC's public subnets"
  default     = []
}

#
# VPCE
#
variable "enable_vpce_datadog" {
  description = "enables/disables creation of DataDog VPC Endpoints"
  default     = 1
}

variable "enable_vpce_aws" {
  description = "enables/disables creation of common AWS Service VPC Endpoints"
  default     = 1
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "extended_subnet_naming" {
  description = "whether extended naming convention is used. qa0x uses extended naming"
  default     = false
}

locals {
  # Creates three /19 private subnets and three /20 public subnets based on CIDR block
  subnets_main         = var.cidr_block_main != "" ? flatten(cidrsubnets(var.cidr_block_main, 3, 3, 3, 4, 4, 4)) : []
  private_subnets_main = var.cidr_block_main != "" ? slice(local.subnets_main, 0, 3) : []
  public_subnets_main  = var.cidr_block_main != "" ? slice(local.subnets_main, 3, 6) : []

  subnets_nc         = var.cidr_block_nc != "" ? flatten(cidrsubnets(var.cidr_block_nc, 3, 3, 3, 4, 4, 4)) : []
  private_subnets_nc = var.cidr_block_nc != "" ? slice(local.subnets_nc, 0, 3) : []
  public_subnets_nc  = var.cidr_block_nc != "" ? slice(local.subnets_nc, 3, 6) : []

  subnets_pritunl         = var.cidr_block_pritunl != "" ? flatten(cidrsubnets(var.cidr_block_pritunl, 3, 3, 3, 4, 4, 4)) : []
  private_subnets_pritunl = var.cidr_block_pritunl != "" ? slice(local.subnets_pritunl, 0, 3) : []
  public_subnets_pritunl  = var.cidr_block_pritunl != "" ? slice(local.subnets_pritunl, 3, 6) : []

  subnets_env         = var.cidr_block_env != "" ? flatten(cidrsubnets(var.cidr_block_env, 3, 3, 3, 4, 4, 4)) : []
  private_subnets_env = var.cidr_block_env != "" ? slice(local.subnets_env, 0, 3) : []
  public_subnets_env  = var.cidr_block_env != "" ? slice(local.subnets_env, 3, 6) : []
}
