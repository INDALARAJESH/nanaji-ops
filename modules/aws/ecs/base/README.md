# ECS Base

### General

* Description: A module to create ECS Base
* Created By: Joe Perez
* Module Dependencies: `ecs-alb`, rendered iam policy, alb target group, and rendered task definition
* Provider Dependencies: `aws` (>2.46), `template`

![aws-ecs-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecs-base/badge.svg)
### Usage

* Terraform:

```hcl
module "ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.6"

  container_name           = "dms-${var.env}"
  container_port           = "1234"
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  ecs_service_tg_arn       = module.alb.tg_arn
  env                      = var.env
  service                  = "dms"
  service_role             = "web"
  td_container_definitions = data.template_file.dms_td_primary.rendered
  vpc_name_prefix          = "nc"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                          | Options                  |   Type   | Required? | Notes |
| :---------------------------- | :----------------------------------- | :----------------------- | :------: | :-------: | :---- |
| ecs_service_platform_version  | Platform version for fargate         | (Default: 1.4.0)         |  string  |    no     | N/A   |
| ecs_execution_iam_policy      | rendered execution IAM policy        | rendered iam policy      | template |    Yes    | N/A   |
| ecs_task_iam_policy           | rendered task role IAM policy        | rendered iam policy      | template |    Yes    | N/A   |
| ecs_service_desired_count     | container count                      | 1...n  (Default: 2)      |   int    |    No     | N/A   |
| ecs_service_tg_arn            | target group arn                     | ARN                      |  string  |    Yes    | N/A   |
| env                           | unique environment/stage name        |                          |  string  |    Yes    | N/A   |
| container_name                | unique name for container            |                          |  string  |    Yes    | N/A   |
| container_port                | TCP port for container               |                          |  string  |    Yes    | N/A   |
| service                       | service name                         | hermosa, flex, etc       |  string  |    Yes    | N/A   |
| service_role                  | sub-component for service            | web, task, manage, etc   |  string  |    Yes    | N/A   |
| td_container_definitions      | task definition for container        | rendered task definition | template |    Yes    | N/A   |
| vpc_name_prefix               | vpc prefix for ecs placement         | nc, more to come         |  string  |    No     | N/A   |
| custom_vpc_name               | vpc name for ecs placement           | uat                      |  string  |    No     | N/A   |
| additional_security_group_ids | additional security groups           |                          |   list   |    No     | N/A   |
| host_volumes                  | hosts volumes                        |                          |   list   |    No     | N/A   |
| enable_execute_command        | enable execute command flag          |                          |   bool   |    No     | N/A   |
#### Outputs

| Variable Name         | Description                                                       |  Type  | Notes |
| :-------------------- | :---------------------------------------------------------------- | :----: | :---- |
| cluster_id            | Cluster ID for services and task definition modules to consume    | string |       |
| app_iam_role          | IAM role ARN to be consumed by other ecs service definitions      | string |       |
| app_security_group_id | security group ID to be consumed by other ecs service definitions | string |       |


### Notes

* After first creation and attachment of the task definition to the ECS service, changes are ignored because task definition updates and deployments are handled separately via jenkins

### Lessons Learned

* The variable `container_name` is strategically placed to make resources play nicely together
* The ECS task definition asks for the ECR repo url, so the ECR creation cannot happen inside this module because the task definition is being rendered before the module has a chance to create the ECR repo.
* ALB Target groups can only have alphanumeric characters and hyphens
* The AWS ECS Service resource doesn't like underscores
* Certificates are region specific, we should start incorporating the region into dns zone names and certs, eg. `stg.useast1.chownow.com`


### References
