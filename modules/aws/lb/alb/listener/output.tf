output "listener_arn" {
  value = var.listener_da_type == "forward" ? join(",", aws_alb_listener.forward.*.arn) : join(",", aws_alb_listener.fixed-response.*.arn)
}

output "listener_port" {
  value = var.listener_port
}

output "listener_protocol" {
  value = var.listener_protocol
}
