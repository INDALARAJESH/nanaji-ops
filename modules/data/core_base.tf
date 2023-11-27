# core base. see: `modules/chownow/aws/core/base`
data "terraform_remote_state" "core_base_callers" {
  backend = "s3"
  config = {
    bucket = "chownow-terraform-remote-state-v4-${local.env}"
    key    = "${var.env}/us-east-1/core/base/terraform.tfstate"
    region = "us-east-1"
  }
}

# main VPC, should always exist, but is theoretically conditional
output "main_gateway_private" {
  value       = try(local.xform.core_base.main_gateway_private, null)
  description = "[string] private connectivity default route gateway id. Usually a nat gateway."
}

output "main_gateway_public" {
  value       = try(local.xform.core_base.main_gateway_public, null)
  description = "[string] public connectivity default route gateway id. Usually an internet gateway."
}

output "main_private_subnet_ids" {
  value       = try(local.xform.core_base.main_subnets_private, null)
  description = "[list<string>] subnet ids that provide private infrastructure for the main vpc."
}

output "main_public_subnet_ids" {
  value       = try(local.xform.core_base.main_subnets_public, null)
  description = "[list<string>] subnet ids that provide public infrastructure for the main vpc."
}

output "main_rtb_private" {
  value       = try(local.xform.core_base.main_rtb_private, null)
  description = "[string] route table id for main vpc private subnets."
}

output "main_rtb_public" {
  value       = try(local.xform.core_base.main_rtb_public, null)
  description = "[string] route table id for main vpc public subnets."
}


# non cardholder VPC, should always exist, but is theoretically conditional
output "nc_gateway_private" {
  value       = try(local.xform.core_base.nc_gateway_private, null)
  description = "[string] private connectivity default route gateway id. Usually a nat gateway."
}

output "nc_gateway_public" {
  value       = try(local.xform.core_base.nc_gateway_public, null)
  description = "[string] public connectivity default route gateway id. Usually an internet gateway."
}

output "nc_private_subnet_ids" {
  value       = try(local.xform.core_base.nc_subnets_private, null)
  description = "[list<string>] subnet ids that provide private infrastructure for the non-cardholder vpc."
}

output "nc_public_subnet_ids" {
  value       = try(local.xform.core_base.nc_subnets_public, null)
  description = "[list<string>] subnet ids that provide public infrastructure for the non-cardholder vpc."
}

output "nc_rtb_private" {
  value       = try(local.xform.core_base.nc_rtb_private, null)
  description = "[string] route table id for non-cardholder vpc private subnets."
}

output "nc_rtb_public" {
  value       = try(local.xform.core_base.nc_rtb_public, null)
  description = "[string] route table id for non-cardholder vpc public subnets."
}

