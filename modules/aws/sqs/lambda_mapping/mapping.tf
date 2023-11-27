resource "aws_lambda_event_source_mapping" "sqs2lambda_map" {
  event_source_arn = data.aws_sqs_queue.existing.arn
  function_name    = var.lambda_function_arn
  batch_size       = var.mapping_batch_size

  function_response_types            = var.function_response_types
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds


  # maximum concurrency must be a valid numeric value if present, so we omit if null
  dynamic "scaling_config" {
    for_each = var.maximum_concurrency == null ? [] : [1]

    content {
      maximum_concurrency = var.maximum_concurrency
    }
  }
}
