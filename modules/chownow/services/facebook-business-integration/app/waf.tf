resource "aws_wafregional_ipset" "whitelist" {

  name = "waf-ipset-app-${local.app_name}-${local.env}"

  dynamic "ip_set_descriptor" {
    for_each = var.ip_set_descriptors

    content {
      type  = ip_set_descriptor.value.type
      value = ip_set_descriptor.value.value
    }
  }
}

# "Only alphanumeric characters allowed in "metric_name"
resource "aws_wafregional_rule" "whitelist" {

  metric_name = "wafApp${replace(title(local.app_name), "-", "")}IpSet"
  name        = "waf-rule-app-${local.app_name}-${local.env}"

  predicate {
    data_id = aws_wafregional_ipset.whitelist.id
    negated = false
    type    = "IPMatch"
  }

  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", "wafApp${replace(title(local.app_name), "-", "")}IpSet",
    )
  )

  depends_on = [aws_wafregional_ipset.whitelist]
}

resource "aws_wafregional_web_acl" "app" {

  name        = "waf-acl-app-${local.app_name}-${local.env}"
  metric_name = "tfApp${replace(title(local.app_name), "-", "")}WebACL"

  default_action {
    type = "BLOCK"
  }

  rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_wafregional_rule.whitelist.id
    type     = "REGULAR"
  }

  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", "waf-acl-app-${local.app_name}-${local.env}",
    )
  )

  depends_on = [aws_wafregional_ipset.whitelist, aws_wafregional_rule.whitelist]
}

resource "aws_wafregional_web_acl_association" "app" {
  resource_arn = module.api_gateway_lambda_integration.stage_arn
  web_acl_id   = aws_wafregional_web_acl.app.id
}
