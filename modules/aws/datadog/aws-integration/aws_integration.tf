# Using Amazon CloudWatch Metric Streams and Amazon Kinesis Data Firehose,
# you can get CloudWatch metrics into Datadog faster with a 2-3 minute latency.
# This is significantly faster than Datadog’s API polling approach, which provides updated metrics every 10 minutes.
resource "aws_cloudformation_stack" "aws_integration" {
  name         = local.name
  capabilities = var.dd_capabilities
  parameters = {

    DdApiKey    = data.aws_secretsmanager_secret_version.ops_api_key.arn
    IAMRoleName = local.name
    ExternalId  = var.integration_external_id
  }
  # template_url = "https://datadog-cloudformation-stream-template.s3.amazonaws.com/aws/streams_main.yaml"

  template_body = file("${path.module}/templates/datadog_aws_integration.yml")

  // lifecycle {
  //   ignore_changes = [parameters]
  // }

}
