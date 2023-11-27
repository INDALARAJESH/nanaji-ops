resource "aws_alb_listener_rule" "host_header" {
  count        = length(var.host_header_values) > 0 && length(var.weighted_target_groups) == 0 ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = var.listener_rule_action_type
    target_group_arn = var.target_group_arns[count.index]
  }

  condition {
    host_header {
      values = var.host_header_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_alb_listener_rule" "host_header_weighted" {
  count        = length(var.host_header_values) > 0 && length(var.weighted_target_groups) > 0 && var.listener_rule_action_type == "forward" ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type = var.listener_rule_action_type
    forward {
      dynamic "target_group" {
        for_each = var.weighted_target_groups
        content {
          arn    = target_group.value.target_group_arn
          weight = target_group.value.weight
        }
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  condition {
    host_header {
      values = var.host_header_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_alb_listener_rule" "path_pattern" {
  count        = length(var.path_pattern_values) > 0 && length(var.target_group_arns) > 0 && length(var.weighted_target_groups) == 0 ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = var.listener_rule_action_type
    target_group_arn = var.target_group_arns[count.index]
  }

  condition {
    path_pattern {
      values = var.path_pattern_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_alb_listener_rule" "path_pattern_weighted" {
  count        = length(var.path_pattern_values) > 0 && length(var.weighted_target_groups) > 0 && var.listener_rule_action_type == "forward" ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type = var.listener_rule_action_type
    forward {
      dynamic "target_group" {
        for_each = var.weighted_target_groups
        content {
          arn    = target_group.value.target_group_arn
          weight = target_group.value.weight
        }
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  condition {
    path_pattern {
      values = var.path_pattern_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_alb_listener_rule" "http_header" {
  count        = length(var.http_header_values) > 0 && length(var.weighted_target_groups) == 0 ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = var.listener_rule_action_type
    target_group_arn = var.target_group_arns[count.index]
  }

  condition {
    http_header {
      http_header_name = var.http_header_name
      values           = var.http_header_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_alb_listener_rule" "http_header_weighted" {
  count        = length(var.http_header_values) > 0 && length(var.weighted_target_groups) > 0 && var.listener_rule_action_type == "forward" ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type = var.listener_rule_action_type
    forward {
      dynamic "target_group" {
        for_each = var.weighted_target_groups
        content {
          arn    = target_group.value.target_group_arn
          weight = target_group.value.weight
        }
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  condition {
    http_header {
      http_header_name = var.http_header_name
      values           = var.http_header_values
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_lb_listener_rule" "redirect" {
  count        = var.listener_rule_action_type == "redirect" ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type = var.listener_rule_action_type

    redirect {
      host        = var.redirect_host
      path        = var.redirect_path_destination
      query       = var.redirect_query
      port        = var.redirect_port
      protocol    = var.redirect_protocol
      status_code = var.redirect_status_code
    }
  }

  condition {
    path_pattern {
      values = var.redirect_path_origin
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}
