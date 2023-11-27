# Single Redirects resource
resource "cloudflare_ruleset" "single_redirects" {
  zone_id     = var.cloudflare_zone_id
  name        = var.cloudflare_name
  description = var.cloudflare_description
  kind        = var.cloudflare_kind
  phase       = var.cloudflare_phase

  dynamic "rules" {
    for_each = var.rules
    content {
      action = rules.value.action
      action_parameters {
        from_value {
          status_code = rules.value.status_code
          target_url {
            value      = lookup(rules.value, "target_url_value", null)
            expression = lookup(rules.value, "target_url_expression", null)
          }
          preserve_query_string = rules.value.preserve_query_string
        }
      }
      expression  = rules.value.expression
      description = rules.value.description
      enabled     = rules.value.enabled
    }
  }
}
