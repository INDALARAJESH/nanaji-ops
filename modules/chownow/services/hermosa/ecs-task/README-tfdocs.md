<!-- BEGIN_TF_DOCS -->
# Hermosa Task on ECS

### General

* Description: Hermosa Task on ECS. This module deploys a task service with IAM roles.
* Created By: Sebastien Plisson
* Module Dependencies: `ecs_configuration`,`ecs_service`,`autoscale`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-task](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-task/badge.svg)

## Usage

* Terraform:

```hcl
module "task" {
  source                       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-task?ref=cn-hermosa-ecs-task-v2.4.0"
  env                          = var.env
  env_inst                     = var.env_inst
  service                      = var.service
  service_id                   = "task"
  cluster_name                 = local.cluster_name
  wait_for_steady_state        = var.wait_for_steady_state
  configuration_secret_arn     = module.secrets.configuration_secret_arn
  task_ecr_repository_uri      = var.task_ecr_repository_uri
  task_container_image_version = var.task_container_image_version
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | ECS cluster name | `string` | `""` | no |
| configuration\_secret\_arn | configuration secret arn | `any` | n/a | yes |
| dd\_agent\_container\_image\_version | Datadog agent container image version (tag) | `string` | `"7"` | no |
| dd\_trace\_enabled | Enable/disable datadog dd\_trace | `bool` | `true` | no |
| deployment\_suffix | suffix to differentiate deployments | `string` | `""` | no |
| enable\_execute\_command | enable execution of command into a container | `bool` | `true` | no |
| enable\_sysdig | enable/disable sysdig | `bool` | `false` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| firelens\_container\_image\_version | firelens container image version (tag) | `string` | `"2.25.1"` | no |
| firelens\_container\_name | firelens container name | `string` | `"log_router"` | no |
| firelens\_container\_ssm\_parameter\_name | firelens container ssm parameter name | `string` | `"/aws/service/aws-for-fluent-bit"` | no |
| firelens\_options\_dd\_host | Host URI of the datadog log endpoint | `string` | `"http-intake.logs.datadoghq.com"` | no |
| ops\_config\_version | version of ops repository used to generate the configuration | `string` | `"master"` | no |
| read\_only\_root\_filesystem | make the container root filesystem readonly | `bool` | `false` | no |
| service | name of service | `string` | `"hermosa"` | no |
| service\_id | unique service suffix | `string` | `""` | no |
| sns\_topic\_arns | Allow override of list of SNS topic ARNs for Hermosa to be able to send messages to | `list` | `[]` | no |
| sqs\_queue\_arns | Allow override of list of SQS queue ARNs for Hermosa to be able to send messages to | `list` | `[]` | no |
| ssm\_kms\_key\_arn | kms key used to encrypt communication with client and executeCommand logs | `string` | `""` | no |
| ssm\_logs\_cloudwatch\_log\_group\_arn | cloudwatch log group to write executeCommand logs | `string` | `""` | no |
| ssm\_logs\_s3\_bucket\_arn | S3 bucket to write executeCommand logs | `string` | `""` | no |
| sysdig\_agent\_container\_image\_version | Sysdig workload agent container image version (tag) | `string` | `"latest"` | no |
| sysdig\_orchestrator\_port | Sysdig ECS Orchestrator port | `number` | `6667` | no |
| task\_command | task container command | `list` | ```[ "/bin/bash", "/opt/chownow/ecs/start_hermosa_task.sh" ]``` | no |
| task\_container\_image\_version | the task container image version | `string` | `"task-latest"` | no |
| task\_cpu | minimum cpu required for the task to be scheduled | `number` | `2048` | no |
| task\_ecr\_repository\_uri | ECR repository uri for the task container | `string` | `""` | no |
| task\_ecs\_service\_desired\_count | desired number of task task instances to run | `number` | `2` | no |
| task\_memory | minimum memory required for the task to be scheduled | `number` | `4096` | no |
| vpc\_name | vpc name | `string` | `"main-dev"` | no |
| wait\_for\_steady\_state | wait for deployment to be ready | `bool` | `true` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
