<!-- BEGIN_TF_DOCS -->
# ECS Web Service

### General

* Description: A module to create an ECS service with target groups attached to load balancers
* Created By: Joe Perez, Warren Nisley
* Module Dependencies: `ecs-base`, `task definition template`
* Provider Dependencies: `aws`

![aws-ecs-web-service](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecs-web-service/badge.svg)

## Usage

* Terraform:

```hcl
module "ecs_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/web-service?ref=aws-ecs-web-service-v2.1.1"

  ecs_execution_iam_policy = data.template_file.dms_ecs_execution_policy_base.rendered
  ecs_task_iam_policy      = data.template_file.dms_ecs_app_policy_base.rendered
  app_security_group_id    = module.ecs.app_security_group_id
  container_name           = "dms-app"
  container_port           = "1234"
  ecs_service_tg_arn       = [data.aws_lb_target_group.tg.arn]
  ecs_cluster_id           = data.aws_ecs_cluster.app.arn
  env                      = "sb"
  service                  = "dms"
  service_role             = "task"
  td_container_definitions = data.template_file.dms_td_task.rendered
  vpc_name_prefix          = "nc"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_tg\_hc\_matcher | ALB target group health check matcher | `string` | `"200"` | no |
| alb\_tg\_hc\_path | ALB target group health check path | `string` | `"/health"` | no |
| alb\_tg\_hc\_protocol | ALB target group health check protocol | `string` | `"HTTP"` | no |
| alb\_tg\_protocol | ALB target group protocol | `string` | `"HTTP"` | no |
| alb\_tg\_target\_type | ALB target group target type | `string` | `"ip"` | no |
| app\_security\_group\_ids | list of ECS service security group ids | `any` | n/a | yes |
| container\_name | ECS Service container name | `string` | `""` | no |
| container\_port | ECS Service container port | `string` | `""` | no |
| custom\_ecs\_service\_name | custom ECS Service name | `string` | `""` | no |
| custom\_vpc\_name | VPC name which is used to determine where to create resources | `string` | `""` | no |
| ecs\_cluster\_id | ECS cluster to attach to | `any` | n/a | yes |
| ecs\_execution\_iam\_policy | ecs execution IAM policy | `any` | n/a | yes |
| ecs\_service\_desired\_count | ECS service count | `number` | `2` | no |
| ecs\_service\_launch\_type | launch type for ECS service | `string` | `"FARGATE"` | no |
| ecs\_service\_platform\_version | platform version for Fargate | `string` | `"1.4.0"` | no |
| ecs\_service\_tg\_arns | Map of target group ARNs to attach in load balancer blocks. ie [ { lb1: "arn" } ] | `map` | `{}` | no |
| ecs\_task\_iam\_policy | ecs task IAM policy | `any` | n/a | yes |
| enable\_execute\_command | enable execution of command into a container | `bool` | `false` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| host\_volumes | n/a | `list(map(string))` | `[]` | no |
| log\_retention\_in\_days | cloudwatch log retention in days | `string` | `"90"` | no |
| propagate\_tags | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK\_DEFINITION | `string` | `"SERVICE"` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| service\_role | node type web/admin/api/app | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| task\_iam\_role\_policy | Rendered IAM JSON policy to attach to the service IAM role (Required if task\_iam\_role\_arn is empty) | `string` | `"{}"` | no |
| td\_container\_definitions | ECS task definition's container definitions | `any` | n/a | yes |
| td\_cpu | ECS task definition cpu mode | `string` | `"1024"` | no |
| td\_memory | ECS task definition memory allocation | `string` | `"2048"` | no |
| td\_network\_mode | ECS task definition network mode | `string` | `"awsvpc"` | no |
| td\_requires\_capabilities | ECS task definition requires compatibilities list | `list` | ```[ "FARGATE" ]``` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `string` | `""` | no |
| vpc\_private\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"private_base"` | no |
| vpc\_public\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"public_base"` | no |
| wait\_for\_steady\_state | wait for service to come up as healthy before finishing terraform run | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_ecs\_task\_definition | n/a |
| cloudwatch\_log\_group\_name | n/a |
| service\_desired\_count | n/a |
| service\_name | Conditional output for evaluating whether the service created is one with a target group or not |

### Lessons Learned

* Terraform will run pre-validations on resources regardless of _count_ values. This leads to problems when attempting to conditionally create iam policy documents with policy = "" if count = "${var.is_equal_to_0}" else policy = "${var.policy_document}"
  * https://github.com/hashicorp/terraform/issues/20892#issuecomment-478847896

* To replace a web service with minimal downtime, enable `create_before_destroy` give the service custom name with the `custom_ecs_service_name` variable, and set the `wait_for_steady_state` to true. This will create a service with a new name, once terraform is done applying, you can remove the `custom_ecs_service_name` and apply again to get back to the original name. After that you can disable `create_before_destroy` and `wait_for_steady_state`

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->