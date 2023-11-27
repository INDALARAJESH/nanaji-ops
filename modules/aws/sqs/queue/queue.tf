resource "aws_sqs_queue" "queue" {
  name = local.sqs_queue_name

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  fifo_queue                 = var.fifo_queue
  redrive_policy             = var.redrive_policy

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.sqs_queue_name }
  )
}
