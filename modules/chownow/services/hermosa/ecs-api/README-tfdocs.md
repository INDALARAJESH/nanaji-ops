<!-- BEGIN_TF_DOCS -->
# Hermosa API on ECS

### General

* Description: Hermosa API on ECS. This module deploys a web service with IAM roles, security group to access Hermosa persistence layer and a target group associated with the ECS service.
* Created By: Sebastien Plisson
* Module Dependencies: `alb_ecs_tg`,`ecs_web_service`,`autoscale`,`ecs_service`,`ecs_configuration`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-api](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-api/badge.svg)

## Usage

* Terraform:

```hcl
module "api" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-api?ref=cn-hermosa-ecs-api-v2.4.5"
  env                         = var.env
  env_inst                    = var.env_inst
  service                     = var.service
  service_id                  = "api"
  alb_name                    = local.alb_name_api
  cluster_name                = local.cluster_name
  alb_hostnames               = [local.api_hostname]
  listener_rule_priority      = 2
  wait_for_steady_state       = var.wait_for_steady_state
  configuration_secret_arn    = module.secrets.configuration_secret_arn
  ssl_key_secret_arn          = module.secrets.ssl_key_secret_arn
  ssl_cert_secret_arn         = module.secrets.ssl_cert_secret_arn
  web_ecr_repository_uri      = var.web_ecr_repository_uri
  web_container_image_version = var.web_container_image_version
  api_ecr_repository_uri      = var.api_ecr_repository_uri
  api_container_image_version = var.api_container_image_version
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_hostnames | hostnames to point to the alb | `list(string)` | `[]` | no |
| alb\_name | ALB load balancer name | `string` | `""` | no |
| api\_command | api container command | `list` | ```[ "/bin/bash", "/opt/chownow/ecs/start_hermosa_api.sh" ]``` | no |
| api\_container\_image\_version | the api container image version | `string` | `"api-latest"` | no |
| api\_container\_port | api container ingress TCP port | `string` | `"1180"` | no |
| api\_ecr\_repository\_uri | ECR repository uri for the api container | `string` | `""` | no |
| cloudflare\_domain | cloudflare domain name to use for resource creation | `string` | `"cdn.cloudflare.net"` | no |
| cloudflare\_hostnames | hostnames to point to cloudflare dns | `list(string)` | `[]` | no |
| cluster\_name | ECS cluster name | `string` | `""` | no |
| configuration\_secret\_arn | configuration secret arn | `any` | n/a | yes |
| dd\_agent\_container\_image\_version | Datadog agent container image version (tag) | `string` | `"7"` | no |
| dd\_trace\_enabled | Enable/disable datadog dd\_trace | `bool` | `true` | no |
| deployment\_suffix | suffix to differentiate deployments | `string` | `""` | no |
| dns\_ttl | TTL on route53 records | `string` | `"300"` | no |
| domain | domain name to use for resource creation | `string` | `"chownow.com"` | no |
| domain\_public | public domain name information | `string` | `"svpn.chownow.com"` | no |
| enable\_egress\_allow\_all | boolean to enable egress allow all | `number` | `1` | no |
| enable\_execute\_command | enable execution of command into a container | `bool` | `true` | no |
| enable\_sysdig | enable/disable sysdig | `bool` | `false` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.25.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log_router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| listener\_rule\_priority | priority of default listener rule | `number` | `5` | no |
| manage\_command | manage container command | `list` | ```[ "/bin/bash", "/opt/chownow/ecs/data_update.sh" ]``` | no |
| manage\_container\_image\_version | the manage container image version | `string` | `"manage-latest"` | no |
| manage\_ecr\_repository\_uri | ECR repository uri for the manage container | `string` | `""` | no |
| manage\_task\_cpu | minimum cpu required for the manage task to be scheduled | `number` | `2048` | no |
| manage\_task\_memory | minimum memory required for the manage task to be scheduled | `number` | `4096` | no |
| ops\_config\_version | version of ops repository used to generate the configuration | `string` | `"master"` | no |
| read\_only\_root\_filesystem | make the container root filesystem readonly | `bool` | `false` | no |
| service | name of service | `string` | `"hermosa"` | no |
| service\_id | unique service suffix | `string` | `""` | no |
| sns\_topic\_arns | Allow override of list of SNS topic ARNs for Hermosa to be able to send messages to | `list` | `[]` | no |
| sqs\_queue\_arns | Allow override of list of SQS queue ARNs for Hermosa to be able to send messages to | `list` | `[]` | no |
| ssl\_cert\_secret\_arn | ssl\_cert secret arn | `any` | n/a | yes |
| ssl\_key\_secret\_arn | ssl\_key secret arn | `any` | n/a | yes |
| ssm\_kms\_key\_arn | kms key used to encrypt communication with client and executeCommand logs | `string` | `""` | no |
| ssm\_logs\_cloudwatch\_log\_group\_arn | cloudwatch log group to write executeCommand logs | `string` | `""` | no |
| ssm\_logs\_s3\_bucket\_arn | S3 bucket to write executeCommand logs | `string` | `""` | no |
| sysdig\_agent\_container\_image\_version | Sysdig workload agent container image version (tag) | `string` | `"latest"` | no |
| sysdig\_orchestrator\_port | Sysdig ECS Orchestrator port | `number` | `6667` | no |
| task\_cpu | minimum cpu required for the task to be scheduled | `number` | `2048` | no |
| task\_memory | minimum memory required for the task to be scheduled | `number` | `4096` | no |
| vpc\_name | vpc name | `string` | `"main-dev"` | no |
| wait\_for\_steady\_state | wait for deployment to be ready | `bool` | `true` | no |
| web\_command | command list for web container | `list` | ```[ "/opt/chownow/ecs/start_hermosa_web.sh" ]``` | no |
| web\_container\_deregistration\_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds | `number` | `5` | no |
| web\_container\_healthcheck\_interval | web container healthcheck interval | `number` | `20` | no |
| web\_container\_healthcheck\_target | web container healthcheck endpoint | `string` | `"/health"` | no |
| web\_container\_healthcheck\_timeout | web container healthcheck timeout | `number` | `10` | no |
| web\_container\_image\_version | the image version used to start the web container | `string` | `"web-latest"` | no |
| web\_container\_port | web container ingress TCP port | `string` | `"8443"` | no |
| web\_ecr\_repository\_uri | ECR repository uri for the web container | `any` | n/a | yes |
| web\_ecs\_service\_desired\_count | desired number of web task instances to run | `number` | `2` | no |
| webhook\_alb\_hostnames | hostnames to point to the weebhook alb | `list(string)` | `[]` | no |
| webhook\_alb\_name | Optional webhook proxy ALB load balancer name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_arn | n/a |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
