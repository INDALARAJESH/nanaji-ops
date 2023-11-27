<!-- BEGIN_TF_DOCS -->
# Menu Service Base TF Module

### General

* Description: Menu Service base terraform module. This module creates the web ALBs and other resources which are required before creating the hermosa application and database
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `alb-public`, `alb-listener-rule` `alb-target-group`, `route53`, `ecr`, `secrets`
* Module Components:
  * `alb_web`
  * `alb_tg`
  * `alb_listener_rule_default`
  * `alb_cname`
  * `jwt_auth_secret`
  * `ld_sdk_key_secret`
* Providers : `aws`, `random`
* Terraform Version: 0.14.6

![menu-service-infra](https://github.com/ChowNow/menu-service/blob/1959b29bf6842ac3c73b0dad1137015696d981a1/diagrams/menu_service_infra_20220825.png)

## Usage

* Terraform:

```hcl
module "base" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/base?ref=cn-menu-base-v2.0.3"
  env             = var.env
  env_inst        = var.env_inst
  vpc_name_prefix = var.vpc_name_prefix
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_tg\_deregistration\_delay | the amount of time a target group waits for a container to drain in seconds | `number` | `1` | no |
| alb\_tg\_listener\_protocol | ALB Listener protocol | `string` | `"HTTP"` | no |
| alb\_tg\_target\_type | ALB target group target type | `string` | `"ip"` | no |
| container\_web\_port | web container ingress tcp port, e.g. 8003 | `string` | `"8003"` | no |
| domain | domain name information, e.g. chownow.com | `string` | `"chownow.com"` | no |
| enable\_alb\_web | enables/disables alb creation | `number` | `1` | no |
| env | unique environment/stage name | `string` | `"dev"` | no |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| service | name of app/service | `string` | `"menu"` | no |
| service\_id | unique service identifier, eg '-in' => integrations-in | `string` | `""` | no |
| tg\_health\_check\_healthy\_threshold | The number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `2` | no |
| tg\_health\_check\_interval | seconds between heath check | `number` | `5` | no |
| tg\_health\_check\_target | ALB target group health check target | `string` | `"/health"` | no |
| tg\_health\_check\_timeout | seconds when no response means a failed health check | `number` | `2` | no |
| vpc\_name\_prefix | prefix added to var.env to select which vpc the service will on | `string` | `"main"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
