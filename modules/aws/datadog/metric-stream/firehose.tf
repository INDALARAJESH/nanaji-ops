# Using Amazon CloudWatch Metric Streams and Amazon Kinesis Data Firehose,
# you can get CloudWatch metrics into Datadog faster with a 2-3 minute latency.
# This is significantly faster than Datadog’s API polling approach, which provides updated metrics every 10 minutes.
resource "aws_cloudformation_stack" "datadog_firehose" {
  name         = local.name
  capabilities = var.dd_capabilities
  parameters = {
    ApiKey  = data.aws_secretsmanager_secret_version.ops_api_key.arn
    Regions = "us-east-1"
  }
  # template_url = "https://datadog-cloudformation-stream-template.s3.amazonaws.com/aws/streams_main.yaml"

  template_body = file("${path.module}/templates/datadog_firehose.yml")

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )

  // lifecycle {
  //   ignore_changes = [parameters]
  // }

}
