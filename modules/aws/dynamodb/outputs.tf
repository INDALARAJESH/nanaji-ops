output "provision_dynamodb_table_id" {
  value = var.billing_mode == "PROVISIONED" ? aws_dynamodb_table.provision[0].id : ""
}

output "provision_dynamodb_table_arn" {
  value = var.billing_mode == "PROVISIONED" ? aws_dynamodb_table.provision[0].arn : ""
}

output "provision_dynamodb_table_stream_arn" {
  value = var.billing_mode == "PROVISIONED" ? aws_dynamodb_table.provision[0].stream_arn : ""
}

output "on-demand_dynamodb_table_id" {
  value = var.billing_mode == "PAY_PER_REQUEST" ? aws_dynamodb_table.on-demand[0].id : ""
}

output "on-demand_dynamodb_table_arn" {
  value = var.billing_mode == "PAY_PER_REQUEST" ? aws_dynamodb_table.on-demand[0].arn : ""
}

output "on-demand_dynamodb_table_stream_arn" {
  value = var.billing_mode == "PAY_PER_REQUEST" ? aws_dynamodb_table.on-demand[0].stream_arn : ""
}
