locals {
  # Remaining LD default colors – "405bff", "ff386b"
  ENV_HEX_COLORS = {
    production = "417505"
    local      = "F5A623"
    test       = "F5A623"
    stg        = "D9F9EB"
    qa         = "FCFFE1"
    qa00       = "E2E6FF"
    qa01       = "FFE1E9"
    qa02       = "E2F9FD"
    qa03       = "F1E5FA"
    uat        = "EBFF38"
    uatload    = "3DD6F5"
    dev        = "405BFF"
  }
  # Applies to both projects and envs
  DEFAULT_TAGS = ["terraform"]
}

resource "launchdarkly_project" "project" {
  key  = var.id
  name = var.name

  tags = distinct(concat(var.tags, local.DEFAULT_TAGS))

  dynamic "environments" {
    for_each = var.envs
    iterator = environment

    content {
      key  = environment.value.id
      name = environment.value.name
      color = can(environment.value.color) ? environment.value.color : lookup(
        local.ENV_HEX_COLORS, environment.value.id, "A34FDE"
      )
      tags = can(environment.value.tags) ? distinct(concat(environment.value.tags, local.DEFAULT_TAGS)) : local.DEFAULT_TAGS

      confirm_changes  = environment.value.id == "production"
      require_comments = environment.value.id == "production"
    }
  }
}
