module "schedule_items" {
  depends_on = [module.schedule_base]
  source     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/eventbridge/schedule-item/?ref=aws-eventbridge-schedule-item-v2.0.0"
  env        = var.env
  env_inst   = var.env_inst
  service    = var.service

  for_each                       = var.schedule
  schedule_item_name             = each.key
  schedule_item_expression       = each.value.schedule_expression
  schedule_item_enabled_disabled = var.schedule_item_enabled_disabled

  schedule_item_json = each.value.item_type == "sqs_task" ? jsonencode({
    QueueUrl = data.aws_sqs_queue.target_queue.url
    MessageBody = jsonencode({
      "specversion" : "1.0",
      "type" : "com.chownow.task",
      "source" : var.service,
      "subject" : "task",
      "id" : each.key,
      "time" : "2022-10-28T21:11:07Z", # hardcoded - don't force rebuild
      "datacontenttype" : "application/json",
      "data" : { "task_name" : each.value.function, "kwargs" : {}, "args" : [] }
    })
    }) : each.value.item_type == "handler" ? jsonencode({
    QueueUrl = data.aws_sqs_queue.target_queue.url
    MessageBody = jsonencode({
      "specversion" : "1.0",
      "type" : each.key,
      "source" : var.service,
      "subject" : each.value.function,
      "id" : each.key,
      "time" : "2022-10-28T21:11:07Z", # hardcoded - don't force rebuild
      "datacontenttype" : "application/json",
      "data" : {}
    })
  }) : "unknown item_type"
}
