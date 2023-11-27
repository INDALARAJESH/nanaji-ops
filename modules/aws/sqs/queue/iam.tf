# If no custom queue policy is passed, the AWS managed default queue policy is added to the queue.
# This policy allows the principal of the root account to perform all actions on the queue, so actors
# managed in IAM in the account can access the queue with their appropriate IAM permissions.
resource "aws_sqs_queue_policy" "custom_queue_policy" {
  count = local.has_custom_queue_policy ? 1 : 0

  queue_url = aws_sqs_queue.queue.id
  policy    = var.custom_queue_policy_json
}
