resource "aws_lambda_event_source_mapping" "sqs2lambda_map" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_alias.handler_alias.arn
  batch_size       = var.mapping_batch_size

  # required by Lambda Powertools Batch Processor for batch processing
  # https://awslabs.github.io/aws-lambda-powertools-python/latest/utilities/batch/
  function_response_types = ["ReportBatchItemFailures"]
}
