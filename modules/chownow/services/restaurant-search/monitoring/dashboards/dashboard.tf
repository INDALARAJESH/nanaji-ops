module "restaurant_search_etl_dashboard" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/dashboard?ref=dd-dashboard-v2.0.0"

  rendered_dashboard_definition = data.template_file.rss_etl_dashboard_template.rendered
}


module "restaurant_search_dms_migration_dashboard" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/dashboard?ref=dd-dashboard-v2.0.0"

  rendered_dashboard_definition = data.template_file.rss_dm_dashboard_template.rendered
}
