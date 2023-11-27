<!-- BEGIN_TF_DOCS -->
# Terraform - Hermosa Routing

## General

* Description: A module to manage routing and traffic distribution between 2 sets of Hermosa target groups
* Created By: Sebastien Plisson
* Terraform Version: 0.14.x

![cn-services-hermosa-routing](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-routing/badge.svg)

## Usage

* Terraform:

```hcl
# Example: standard blue-green
module "routing" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
}

# Example: with webhookproxy alb
module "routing_webhook" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  enable_webhook                  = true
  webhook_alb_name                = "webhookproxy-alb"
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_webhook_blue       = local.target_group_webhook_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  target_group_webhook_green      = local.target_group_webhook_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
}

# Example: single target groups (no traffic disdtribution)
module "routing_single" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/routing?ref=cn-hermosa-routing-v2.1.0"
  env                             = var.env
  env_inst                        = var.env_inst
  listener_rule_priority_interval = var.listener_rule_priority_interval
  listener_rule_priority          = var.listener_rule_priority
  isolated_useragents             = var.isolated_user_agents
  api_alb_name                    = local.api_alb_name
  admin_alb_name                  = local.admin_alb_name
  enable_webhook                  = true
  webhook_alb_name                = "webhookproxy-alb"
  target_group_admin_blue         = local.target_group_admin_blue
  target_group_admin_ck_blue      = local.target_group_admin_ck_blue
  target_group_api_blue           = local.target_group_api_blue
  target_group_webhook_blue       = local.target_group_webhook_blue
  target_group_admin_green        = local.target_group_admin_green
  target_group_admin_ck_green     = local.target_group_admin_ck_green
  target_group_api_green          = local.target_group_api_green
  target_group_webhook_green      = local.target_group_webhook_green
  traffic_distribution_api        = var.traffic_distribution_api
  traffic_distribution_admin      = var.traffic_distribution_admin
  traffic_distribution_admin_ck   = var.traffic_distribution_admin_ck
  api_target_groups               = []
  single_target_group             = true
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_alb\_name | admin ALB name | `any` | n/a | yes |
| admin\_ck\_target\_groups | Optional custom list of target groups for admin\_ck load balancer rules | `list` | `[]` | no |
| admin\_target\_groups | Optional custom list of target groups for admin load balancer rules | `list` | `[]` | no |
| api\_alb\_name | api ALB name | `any` | n/a | yes |
| api\_target\_groups | Optional custom list of target groups for api load balancer rules | `list` | `[]` | no |
| ar\_path\_destination | admin redirect path destination | `string` | `"/#{path}"` | no |
| ar\_query | admin redirect query | `string` | `"#{query}"` | no |
| domain | domain name | `string` | `"chownow.com"` | no |
| enable\_webhook | allows to create listener rules for the webhook ALB listener | `bool` | `false` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| isolated\_useragents | list of user agents to route to the admin\_ck pool | `list` | ```[ "cloudkitchens", "CubohBot/*", "OrderRobot/*" ]``` | no |
| listener\_rule\_priority | priority of first listener rules. Others are of increased priority by var.listener\_rule\_priority\_interval | `number` | `5` | no |
| listener\_rule\_priority\_interval | interval between listener rule priorities | `number` | `5` | no |
| service | name of app/service | `string` | `"hermosa"` | no |
| single\_target\_group | allows to force using a single target group to allow deletion of the unused target group | `bool` | `false` | no |
| subdomain\_api | api subdomain | `string` | `"api"` | no |
| subdomain\_eat | eat subdomain | `string` | `"eat"` | no |
| subdomain\_facebook | facebook subdomain | `string` | `"facebook"` | no |
| subdomain\_ordering | ordering subdomain | `string` | `"ordering"` | no |
| target\_group\_admin\_blue | admin blue deployment target group | `any` | n/a | yes |
| target\_group\_admin\_ck\_blue | admin\_ck blue deployment target group | `any` | n/a | yes |
| target\_group\_admin\_ck\_green | admin \_ck green deployment target group | `any` | n/a | yes |
| target\_group\_admin\_green | admin green deployment target group | `any` | n/a | yes |
| target\_group\_api\_blue | api blue deployment target group | `any` | n/a | yes |
| target\_group\_api\_green | api green deployment target group | `any` | n/a | yes |
| target\_group\_webhook\_blue | webhook blue deployment target group | `string` | `""` | no |
| target\_group\_webhook\_green | webhook green deployment target group | `string` | `""` | no |
| traffic\_distribution\_admin | admin levels of traffic distribution | `string` | `"blue"` | no |
| traffic\_distribution\_admin\_ck | admin\_ck levels of traffic distribution | `string` | `"blue"` | no |
| traffic\_distribution\_api | api levels of traffic distribution | `string` | `"blue"` | no |
| vpc\_name\_prefix | vpc name prefix to use as a location of where to pull data source information and to build resources | `string` | `"main"` | no |
| webhook\_alb\_name | webhook ALB name | `string` | `""` | no |
| webhook\_path\_patterns\_group\_1 | path patterns group 1 (5 max) to match and route on webhook ALB | `list` | ```[ "/yelp/*", "/api/yelp/*", "/api/webhook", "/api/webhook/*" ]``` | no |
| webhook\_path\_patterns\_group\_2 | path patterns group 2 (5 max) to match and route on webhook ALB | `list` | ```[ "/.well-known/apple-developer-merchantid-domain-association", "/api/google-food", "/api/google-food/*" ]``` | no |
| webhook\_rule\_priority\_offset | priority offset for listener rule | `number` | `100` | no |



## Lessons Learned

## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->