<!-- BEGIN_TF_DOCS -->
# Menu Service on ECS

### General

* Description: Menu Service on ECS. This module deploys an API service with IAM roles.
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `ecs`, `autoscale`, `ecs_task`
* Module Components:
  * `ecs_base_web`
  * `ecs_base_autoscale`
  * `ecs_td_manage`
* Providers : `aws`, `random`
* Terraform Version: 0.14.6

![menu-service-infra](https://github.com/ChowNow/menu-service/blob/1959b29bf6842ac3c73b0dad1137015696d981a1/diagrams/menu_service_infra_20220825.png)

## Usage

* Terraform:

```hcl
module "app" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/app?ref=cn-menu-app-v2.0.13"
  env             = var.env
  env_inst        = var.env_inst
  vpc_name_prefix = var.vpc_name_prefix

  container_web_image_registry_url = var.container_web_image_registry_url
  container_web_image_name         = var.container_web_image_name
  container_web_image_tag          = var.container_web_image_tag
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_web\_image\_name | web container image name, e.g. menu-service | `string` | `"menu-service"` | no |
| container\_web\_image\_registry\_url | image registry url, e.g. 449190145484.dkr.ecr.us-east-1.amazonaws.com | `string` | `"449190145484.dkr.ecr.us-east-1.amazonaws.com"` | no |
| container\_web\_image\_tag | web container image tag, e.g. 1c6184d | `any` | n/a | yes |
| container\_web\_port | web container ingress tcp port, e.g. 8003 | `string` | `"8003"` | no |
| database\_name | database name | `string` | `"menu"` | no |
| database\_user | database user | `any` | `"chownow"` | no |
| deployment\_suffix | suffix used to name service and lookup of the name of target group to attach to | `string` | `""` | no |
| env | unique environment/stage name | `string` | `"dev"` | no |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.10.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log_router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| service | name of app/service | `string` | `"menu"` | no |
| service\_id | unique service identifier, eg '-in' => integrations-in | `string` | `""` | no |
| vpc\_name\_prefix | prefix added to var.env to select which vpc the service will on | `string` | `"main"` | no |
| web\_ecs\_service\_desired\_count | desired number of web task instances to run | `number` | `1` | no |
| web\_ecs\_service\_max\_count | max number of web task instances to run | `number` | `8` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
