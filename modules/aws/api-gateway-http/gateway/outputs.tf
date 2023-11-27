output "api_id" {
  description = "id of api gateway"
  value       = aws_apigatewayv2_api.api.id
}

output "stage_id" {
  description = "default stage id"
  value       = aws_apigatewayv2_stage.default.id
}

output "stage_arn" {
  description = "default stage arn"
  value       = aws_apigatewayv2_stage.default.arn
}
