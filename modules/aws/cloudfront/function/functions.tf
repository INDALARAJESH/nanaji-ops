resource "aws_cloudfront_function" "function" {
  name    = "${var.function_name}-${local.env}"
  runtime = var.function_runtime
  comment = "Cloudfront function for ${var.service} in ${local.env}"
  publish = var.function_publish
  code    = var.file_path
}
