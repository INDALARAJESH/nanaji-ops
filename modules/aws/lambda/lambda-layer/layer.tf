resource "aws_lambda_layer_version" "layer" {
  layer_name  = local.layer_classification_lower
  description = var.layer_description

  s3_bucket = aws_s3_bucket.lambda_artifacts.id
  s3_key    = aws_s3_bucket_object.first_lambda_zip.id

  compatible_runtimes = var.layer_compatible_runtimes
}

# Look up the lambda layer to refresh layer version for output.layer_arn
data "aws_lambda_layer_version" "layer" {
  layer_name = aws_lambda_layer_version.layer.layer_name
}
