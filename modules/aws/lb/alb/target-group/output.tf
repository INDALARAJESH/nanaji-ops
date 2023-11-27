output "tg_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.tg.arn
}
