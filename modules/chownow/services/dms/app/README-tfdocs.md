<!-- BEGIN_TF_DOCS -->
# Managed Delivery Service on ECS

### General

* Description: Managed Delivery Service on ECS
* Created By: Devops
* Module Dependencies: `ecs`, `autoscale`, `ecs_task`
* Module Components:
  * `ecs_managecontainers`
  * `ecs_schedulecontainers`
  * `ecs_taskcontainers`
  * `ecs_webcontainers`
* Providers : `aws`
* Terraform Version: 0.14.x

## Usage

* Terraform:

```hcl
module "app" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/app?ref=cn-dms-app-v2.2.9"
  env             = var.env
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_entrypoint\_scheduler | container entrypoint for scheduler definition | `string` | `"/code/dms/entrypoint_celery.sh"` | no |
| container\_entrypoint\_task | container entrypoint for task definition | `string` | `"/code/dms/entrypoint_celery.sh"` | no |
| container\_entrypoint\_web | container entrypoint for task definition | `string` | `"/code/entrypoint.sh"` | no |
| container\_port | ingress TCP port for container | `string` | `"8000"` | no |
| containers\_env\_config | static configuration for adjusting task container env from the caller state.         sendgrid\_delighted\_enabled: [bool] passes this value directly to the container environment. used for sending delighted emails from sendgrid. | ```object({ sendgrid_delighted_enabled = bool })``` | n/a | yes |
| domain | domain name information | `string` | `"chownow.com"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.10.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log_router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| log\_retention\_in\_days | log retention for containers | `number` | `30` | no |
| manage\_container\_tag | The current container tag used in the production deployment | `any` | n/a | yes |
| s3\_bucket\_base\_name | name of the s3 bucket without the environment appended | `string` | `"cn-mds-files"` | no |
| service | name of app/service | `string` | `"dms"` | no |
| task\_container\_tag | The current container tag used in the production deployment | `any` | n/a | yes |
| td\_env\_app\_log\_level | task definition app log level environment variable | `string` | `"INFO"` | no |
| td\_env\_sendgrid\_delighted\_enabled | task definition environment variable to enable/disable sendgrid delighted | `string` | `"false"` | no |
| vpc\_name\_prefix | vpc name prefix to use as a location of where to pull data source information and to build resources | `string` | `"nc"` | no |
| vpc\_private\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"private_base"` | no |
| web\_container\_tag | The current container tag used in the production deployment | `any` | n/a | yes |
| web\_ecs\_config | static configuration for the "web container" ecs service from the caller state.       desired: [int] number of web containers that should be running | ```object({ desired = number })``` | n/a | yes |
| web\_policy\_scale\_in\_cooldown | the amount of time to wait until the next scaling event | `number` | `300` | no |
| web\_scaling\_max\_capacity | maximum amount of containers to support in the autoscaling configuration | `number` | `10` | no |
| web\_scaling\_min\_capacity | minimum amount of containers to support in the autoscaling configuration | `number` | `4` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->