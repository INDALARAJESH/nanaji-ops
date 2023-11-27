# Datadog Forwarder to ship logs from S3 and CloudWatch, as well as observability data from Lambda functions to Datadog.
# https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring
resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = local.name
  capabilities = var.dd_capabilities
  parameters = {
    DdApiKeySecretArn = data.aws_secretsmanager_secret_version.ops_api_key.arn
    DdTags            = "env:${local.dd_env},service:${var.service},managed_by:${var.tag_managed_by}"
    FunctionName      = local.name
  }
  # template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"

  template_body = file("${path.module}/templates/datadog_forwarder.yml")

  // lifecycle {
  //   ignore_changes = [parameters]
  // }

}
