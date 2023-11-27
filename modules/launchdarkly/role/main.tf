resource "launchdarkly_custom_role" "main" {
  key         = var.id
  name        = var.name
  description = var.description

  dynamic "policy_statements" {
    for_each = var.policy_statements
    iterator = statement

    content {
      effect    = statement.value.effect
      resources = statement.value.resources
      actions   = statement.value.actions
    }
  }
}
