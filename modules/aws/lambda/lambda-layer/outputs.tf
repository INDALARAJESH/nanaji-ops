output "layer_name" {
  value = aws_lambda_layer_version.layer.layer_name
}

output "layer_arn" {
  value = data.aws_lambda_layer_version.layer.arn
}
