output "id" {
  description = "integration id of api gateway"
  value       = aws_apigatewayv2_integration.lambda-integration.id
}
