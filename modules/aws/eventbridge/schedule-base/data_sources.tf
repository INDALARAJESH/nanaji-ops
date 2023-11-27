data "aws_sqs_queue" "target_sqs_queue_name" {
  name = local.target_sqs_queue_name
}
