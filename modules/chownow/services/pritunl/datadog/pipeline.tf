resource "datadog_logs_custom_pipeline" "pritunl_audit_logs" {
  filter {
    query = "host:(pritunl-app0-dev OR pritunl-app1-dev OR pritunl-app0-ops OR pritunl-app1-ops)"
  }

  name       = "Pritunl VPN Audit Journal Logs"
  is_enabled = true

  processor {
    arithmetic_processor {
      expression         = "timestamp * 1000"
      target             = "milliseconds_timestamp"
      is_replace_missing = true
      name               = "Convert timestamp to milliseconds"
      is_enabled         = true
    }
  }

  processor {
    attribute_remapper {
      sources              = ["milliseconds_timestamp"]
      source_type          = "attribute"
      target               = "milliseconds_timestamp"
      target_type          = "attribute"
      target_format        = "integer"
      preserve_source      = false
      override_on_conflict = false
      name                 = "Convert milliseconds_timestamp to integer"
      is_enabled           = true
    }
  }

  processor {
    date_remapper {
      sources    = ["milliseconds_timestamp"]
      name       = "Use milliseconds_timestamp for date"
      is_enabled = true
    }
  }
}
