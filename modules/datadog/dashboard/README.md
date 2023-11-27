# Datadog Dashboard

### General

* Description: a terraform module to create a datadog dashboard
* Created By: Keith Erickson
* Module Dependencies:
  * N/A
* Provider Dependencies:
  * Datadog
* Terraform Version: `0.14.x`

![dd-dashboard](https://github.com/ChowNow/ops-tf-modules/workflows/dd-dashboard/badge.svg)

### Usage

example_dashboard.json.tpl
```json
{
  "title": "${service_name}-${local_env}",
  "description": "Example Dashboard"
}

```

```hcl
data "template_file" "example_dashboard_template" {
  template = file("${path.module}/templates/example_dashboard.json.tpl")

  vars = {
    service_name = var.service_name
    local_env    = local.env
  }
}

module "example_dashboard" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/dashboard?ref=dd-dashboard-v2.0.0"

  dashboard = data.template_file.rss_etl_dashboard_template.rendered
}

```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options      |  Type   | Required? | Notes   |
|:--------------|:------------------------------|:-------------| :-----: |:---------:|:--------|
| dashboard     | rendered dashboard definition |              | string  |    Yes    | N/A     |

### Notes
Current implementation for this module involves putting the dashboard definition and widgets in
a json file and passing it through to the module via a rendered template. 

Datadog allows you to copy dashboard json, so you can manually experiment on the dashboard with
widgets and then copy the json and update your `.json.tpl` file.
