<!-- BEGIN_TF_DOCS -->
# Marketplace App

## General

* Description: Marketplace NextJS Terraform module
* Created By: Allen Dantes & Jobin Muthalaly
* Module Dependencies: 
* Module Components:
* Providers : `aws`
* Terraform Version: ~> 0.14.6

![chownow-services-marketplace-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-marketplace-app/badge.svg)

## Workspace

* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── marketplace
            ├── app
            ├──── alb.tf
            ├──── ecs.tf
```

## Usage

* Terraform:

```hcl
module "marketplace_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/marketplace/app?ref=cn-marketplace-app-v2.1.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_enable\_egress\_allow\_all | allow egress all on alb | `string` | `"1"` | no |
| alb\_ingress\_tcp\_allowed | list of allowed TCP ports | `list` | ```[ "443" ]``` | no |
| alb\_logs\_enabled | boolean to enable/disable ALB logging | `bool` | `false` | no |
| alb\_name\_prefix | alb security group name prefix | `string` | `"alb-pub"` | no |
| alb\_tg\_listener\_protocol | ALB Listener protocol | `string` | `"HTTP"` | no |
| alb\_tg\_target\_type | ALB target group target type | `string` | `"ip"` | no |
| branch\_io\_key | Branch IO Key | `string` | `"key_test_af6iSXMCdo6PEjf2LjJJTaleDDpXw7Yz"` | no |
| container\_protocol | protocol spoken on container\_port | `string` | `"HTTP"` | no |
| custom\_alb\_log\_bucket | ALB log bucket name, alb\_logs\_enabled must be on when assigning a bucket | `string` | `"null"` | no |
| custom\_vpc\_name | overrides default vpc for resource placement | `string` | `""` | no |
| dd\_agent\_container\_image\_version | Datadog agent container image version (tag) | `string` | `"7"` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| ecs\_log\_retention\_in\_days | number of days to retain log files | `string` | `"30"` | no |
| ecs\_service\_desired\_count | number of services to run per container | `string` | `"2"` | no |
| enable\_execute\_command | enable execution of command into a container | `bool` | `true` | no |
| enable\_sysdig | enable/disable sysdig | `bool` | `false` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| facebook\_oauth\_app\_id | Application ID for Facebook Oauth | `string` | `"391736507867606"` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.10.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log-router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| google\_analytics\_id | Analytics ID for Google | `string` | `"UA-83904909-2"` | no |
| google\_maps\_client\_key | Client Key for Google Map API | `string` | `"AIzaSyDKks4-Thrc6n-iLK8p-KLRUFq-Jb5i2nk"` | no |
| google\_oauth\_client\_id | Client ID for Google Map API | `string` | `"938991976367-no5a1t6dnds8fulk9cae3mjeropqg43i.apps.googleusercontent.com"` | no |
| health\_check\_interval | ALB target group health check interval in seconds | `number` | `60` | no |
| health\_check\_timeout | The amount of time, in seconds, during which no response means a failed health check. | `number` | `10` | no |
| image\_tag | service image tag | `string` | `"main"` | no |
| launch\_darkly\_id | LaunchDarkly ID | `string` | `"61f8128467ed48159707692c"` | no |
| log\_retention\_in\_days | log retention for containers | `number` | `30` | no |
| marketplace\_command | marketplace container command | `list` | ```[ "/bin/sh", "entrypoint.sh" ]``` | no |
| marketplace\_container\_port | Marketplace TCP port | `string` | `"3000"` | no |
| marketplace\_log\_level | task definition marketplace log level environment variable | `string` | `"INFO"` | no |
| name | short name of app | `string` | `"marketplace"` | no |
| ops\_ecr\_address | ops marketplace repository address | `string` | `"449190145484.dkr.ecr.us-east-1.amazonaws.com"` | no |
| order\_direct\_distribution\_id | Used to find order direct cloudfront record | `any` | n/a | yes |
| private\_zone\_boolean | Toggle private or public zone | `bool` | `true` | no |
| production\_app\_order\_direct\_endpoint | Production Ordering Endpoing | `string` | `""` | no |
| propagate\_tags | specifies how to propagate tags to running tasks, valid values are SERVICE or TASK\_DEFINITION | `string` | `"SERVICE"` | no |
| record\_ttl | TTL for Order Direct Record | `number` | `300` | no |
| sentry\_auth\_token | Sentry Auth Token | `string` | `"eaf8238075114a9e8fef2d5ccba72c92dc4601c7f4e74c079706b49935edc843"` | no |
| sentry\_dsn | Sentry.io API key | `string` | `"https://d905c9e410ab415391a182c46b90578b@o32006.ingest.sentry.io/6108690"` | no |
| service | name of app/service | `string` | `"marketplace"` | no |
| svpn\_subdomain | subdomain name to use for resource creation | `string` | `"svpn"` | no |
| sysdig\_orchestrator\_port | Sysdig ECS Orchestrator port | `number` | `6667` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| tag\_owner | The team which owns these resources | `string` | `"frontend"` | no |
| task\_cpu | CPU units for the container | `string` | `"1024"` | no |
| task\_memory | Memory limit for the container | `string` | `"2048"` | no |
| tg\_health\_check\_target | ALB target group health check target | `string` | `"/api/health"` | no |
| vpc\_name\_prefix | vpc name prefix to use as a location of where to pull data source information and to build resources | `string` | `"nc"` | no |
| vpc\_private\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"private_base"` | no |
| wait\_for\_steady\_state | wait for deployment to be ready | `bool` | `true` | no |
| web\_policy\_scale\_in\_cooldown | the amount of time to wait until the next scaling event | `number` | `300` | no |
| web\_scaling\_max\_capacity | maximum amount of containers to support in the autoscaling configuration | `number` | `8` | no |
| web\_scaling\_min\_capacity | minimum amount of containers to support in the autoscaling configuration | `number` | `2` | no |
| wildcard\_domain\_prefix | allows for the addition of wildcard to the name because some chownow accounts have it | `string` | `""` | no |



## Lessons Learned


## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->