output "alb_name" {
  value = local.alb_name
}

output "alb_arn" {
  value = aws_lb.private.arn
}

output "alb_dns_name" {
  value = aws_lb.private.dns_name
}

output "listener_port" {
  value = var.listener_port
}

output "listener_arn" {
  value = var.listener_da_type == "forward" ? join(",", aws_alb_listener.forward.*.arn) : join(",", aws_alb_listener.fixed-response.*.arn)
}

output "alb_tg_arn" {
  description = "ALB target group ARN when the listener default action type is forward"
  value       = var.listener_da_type == "forward" ? join(",", aws_lb_target_group.forward.*.arn) : ""
}

output "alb_private_zone_id" {
  value = aws_lb.private.zone_id
}
