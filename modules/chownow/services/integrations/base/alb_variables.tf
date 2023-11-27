variable "listener_port" {
  description = "ALB listener port"
  default     = "443"
}

variable "listener_rule_priority" {
  default = 100
}

variable "alb_addtl_hosts" {
  description = "list of additional records to allow for the public alb"
  type        = list(string)
  default     = []
}

variable "enable_canary" {
  description = "enable canary deployment"
  default     = 1
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
  default     = "blue"
}

variable "target_group_arn_blue" {
  description = "allow to use an existing target group arn when adding canary capability to existing deployment"
  default     = ""
}


locals {
  alb_name              = var.enable_alb == 1 ? module.alb_public[0].alb_name : data.aws_lb.public.name
  alb_listener_arn      = var.enable_alb == 1 ? module.alb_public[0].listener_arn : data.aws_lb_listener.public.arn
  target_group_arn_blue = var.target_group_arn_blue != "" ? var.target_group_arn_blue : module.alb_ecs_tg_blue[0].tg_arn
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}
