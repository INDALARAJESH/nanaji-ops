output "lambda_handler_role_arn" {
  description = "the arn of the lambda handler's role"
  value       = aws_iam_role.handler.arn
}

output "lambda_handler_role_name" {
  description = "the name of the lambda handler's role"
  value       = aws_iam_role.handler.name
}

output "lambda_handler_arn" {
  description = "the arn of the lambda handler"
  value       = aws_lambda_function.handler.arn
}

output "lambda_handler_name" {
  description = "the name of the lambda handler"
  value       = aws_lambda_function.handler.function_name
}

output "dlq_queue_name" {
  description = "the name of the handler's DLQ queue"
  value       = aws_sqs_queue.failure_queue.name
}

output "dlq_queue_arn" {
  description = "the arn of the handler's DLQ queue"
  value       = aws_sqs_queue.failure_queue.arn
}

output "queue_name" {
  description = "the name of the handler's SQS queue"
  value       = aws_sqs_queue.queue.name
}

output "queue_arn" {
  description = "the arn of the handler's SQS queue"
  value       = aws_sqs_queue.queue.arn
}

output "lambda_alias_invoke_arn" {
  description = "lambda alias invoke arn"
  value       = aws_lambda_alias.handler_alias.invoke_arn
}
