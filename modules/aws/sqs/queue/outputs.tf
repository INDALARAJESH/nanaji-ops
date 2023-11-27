output "sqs_queue_name" {
  value = aws_sqs_queue.queue.name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.queue.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.queue.arn
}
