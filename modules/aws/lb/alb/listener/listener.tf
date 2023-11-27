###############################
# Fixed-Response ALB Listener #
###############################
resource "aws_alb_listener" "fixed-response" {
  count             = var.listener_da_type == "fixed-response" ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = var.listener_da_type

    fixed_response {
      content_type = var.listener_da_fixed_content_type
      status_code  = var.listener_da_fixed_status_code
    }
  }
}

###########################
# Forwarding ALB Listener #
###########################
resource "aws_alb_listener" "forward" {
  count             = var.listener_da_type == "forward" ? 1 : 0
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = var.listener_da_type
    target_group_arn = var.target_group_arn
  }
}

#####################
# Redirect Listener #
#####################

resource "aws_lb_listener" "redirect" {
  count = var.listener_da_type == "redirect" ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = var.listener_da_type

    redirect {
      host        = var.redirect_host
      path        = var.redirect_path_destination
      query       = var.redirect_query
      port        = var.redirect_port
      protocol    = var.redirect_protocol
      status_code = var.redirect_status_code
    }
  }
}
