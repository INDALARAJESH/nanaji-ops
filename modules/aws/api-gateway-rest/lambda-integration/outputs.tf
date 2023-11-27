output "stage_id" {
  description = "default stage id"
  value       = aws_api_gateway_stage.default.id
}

output "stage_arn" {
  description = "default stage arn"
  value       = aws_api_gateway_stage.default.arn
}

output "stage_name" {
  description = "default stage name"
  value       = aws_api_gateway_stage.default.stage_name
}
