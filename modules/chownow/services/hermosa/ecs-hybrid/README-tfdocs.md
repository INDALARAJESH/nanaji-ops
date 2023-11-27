<!-- BEGIN_TF_DOCS -->
# Hermosa Hybrid

### General

* Description: Hermosa ECS app with managed services
* Created By: Sebastien Plisson
* Module Dependencies: `alb-public`, `alb_ecs_tg`, `alb_ecs_listener_rule` `alb_origin_r53`, `ecs_base`,`autoscale`,`ecs_service`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-hermosa-ecs-hybrid](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-ecs-hybrid/badge.svg)

## Usage

* Terraform:

```hcl
module "hermosa_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-hybrid?ref=hermosa-ecs-hybrid-v2.1.3"

  env = "dev"
  alb_name_prefix = "on-demand-pub"
  cluster_name_prefix = "ondemand"
  alb_hostnames = ["admin.dev.svpn.chownow.com"]
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_hostnames | list of records to allow for the alb | `list(string)` | n/a | yes |
| alb\_name\_prefix | prefix of load balancer, eg: on-demand-pub | `any` | n/a | yes |
| api\_container\_image\_version | the api container image version | `string` | `"api-latest"` | no |
| api\_ecr\_repository\_uri | ECR repository uri for the api container | `string` | `""` | no |
| cluster\_name\_prefix | cluster name prefix | `any` | n/a | yes |
| custom\_alb\_name | specify load balancer name | `string` | `""` | no |
| custom\_cluster\_name | specify cluster name | `string` | `""` | no |
| dd\_agent\_container\_image\_version | Datadog agent container image version (tag) | `string` | `"7"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| ops\_config\_version | the version of ops repository used to generate the configuration | `string` | `"master"` | no |
| service | name of app/service | `string` | `"hermosa"` | no |
| task\_container\_image\_version | the task container image version | `string` | `"task-latest"` | no |
| task\_ecr\_repository\_uri | ECR repository uri for the task container | `string` | `""` | no |
| task\_ecs\_service\_desired\_count | Number of desired instances of task service | `number` | `1` | no |
| wait\_for\_steady\_state | wait for deployment to be ready | `bool` | `true` | no |
| web\_container\_image\_version | the image version used to start the web container | `string` | `"web-latest"` | no |
| web\_ecr\_repository\_uri | ECR repository uri for the web container | `any` | n/a | yes |
| web\_ecs\_service\_desired\_count | Number of desired instances of api service | `number` | `1` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->