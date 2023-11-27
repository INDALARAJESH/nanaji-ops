# "main vpc". output names structured like this for better sorting
output "main_gateway_private" { value = try(module.vpc_main[0].private_gateway_id, null) }
output "main_gateway_public" { value = try(module.vpc_main[0].public_gateway_id, null) }
output "main_rtb_private" { value = try(module.vpc_main[0].private_rtb_id, null) }
output "main_rtb_public" { value = try(module.vpc_main[0].public_rtb_id, null) }
output "main_subnets_private" { value = try(module.vpc_main[0].private_subnet_ids, null) }
output "main_subnets_public" { value = try(module.vpc_main[0].public_subnet_ids, null) }

# "non cardholder" vpc
output "nc_gateway_private" { value = try(module.vpc_nc[0].private_gateway_id, null) }
output "nc_gateway_public" { value = try(module.vpc_nc[0].public_gateway_id, null) }
output "nc_rtb_private" { value = try(module.vpc_nc[0].private_rtb_id, null) }
output "nc_rtb_public" { value = try(module.vpc_nc[0].public_rtb_id, null) }
output "nc_subnets_private" { value = try(module.vpc_nc[0].private_subnet_ids, null) }
output "nc_subnets_public" { value = try(module.vpc_nc[0].public_subnet_ids, null) }
