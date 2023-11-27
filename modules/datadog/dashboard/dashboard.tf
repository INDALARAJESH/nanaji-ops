resource "datadog_dashboard_json" "dashboard" {
  dashboard = var.rendered_dashboard_definition
}
