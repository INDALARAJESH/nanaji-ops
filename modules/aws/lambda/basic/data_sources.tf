# Region lookup

data "aws_region" "current" {}


# Lambda layer lookup

data "aws_lambda_layer_version" "layers" {
  count      = length(var.lambda_layer_names)
  layer_name = var.lambda_layer_names[count.index]
}
