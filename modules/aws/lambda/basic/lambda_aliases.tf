resource "aws_lambda_alias" "newest" {
  count            = var.lambda_publish ? 1 : 0
  name             = "newest"
  description      = "The newest deployed version of this Lambda"
  function_name    = local.lambda_function_name
  function_version = local.lambda_newest_version

  #  https://github.com/hashicorp/terraform-provider-aws/issues/13329
  #  routing_config {
  #    additional_version_weights = {
  #      (aws_lambda_alias.previous[0].function_version) = var.lambda_previous_version_percentage
  #    }
  #  }

  #  Note that you can't manage provisioned concurrency settings on the alias while the routing configuration is in place.
  #   - fix by adding an empty routing configuration to the alias
  # routing_config {}
}
