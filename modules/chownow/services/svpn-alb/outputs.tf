output "alb_name" {
  value = module.alb_public.alb_name
}

output "alb_dns_name" {
  value = module.alb_public.alb_dns_name
}

output "listener_port" {
  value = module.alb_public.listener_port
}

output "listener_arn" {
  value = module.alb_public.listener_arn
}

output "alb_tg_arn" {
  description = "ALB target group ARN when the listener default action type is forward"
  value       = module.alb_public.alb_tg_arn
}
