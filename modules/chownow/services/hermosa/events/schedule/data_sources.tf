data "aws_sqs_queue" "target_queue" {
  name = local.target_sqs_queue_name
}
