resource "aws_sqs_queue" "queue" {
  name = "${var.service}-${var.sqs_queue_name}-${var.env}${var.fifo_queue ? ".fifo" : ""}"

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  # FIFO settings
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue

  sqs_managed_sse_enabled = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.failure_queue.arn
    maxReceiveCount     = var.max_receive_count
  })

}
