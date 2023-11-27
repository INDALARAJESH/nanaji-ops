resource "aws_scheduler_schedule_group" "schedule_group" {
  name = local.schedule_group_name
}
