<!-- BEGIN_TF_DOCS -->
# ECS Task Definition

### General

* Description: A module to create an ECS Task Definition attached to a "base" ECS deployment
* Created By: Joe Perez
* Module Dependencies: `ecs`, `task definition template`

![aws-ecs-task](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecs-task/badge.svg)

## Usage

* Terraform:

```hcl
module "ecs_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.4"

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  env                      = local.env
  service                  = var.service
  service_role             = "manage"
  td_container_definitions = data.template_file.ecs_task_definition.rendered
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cwlog\_group\_name | name of cloudwatch log group for ecs task | `string` | `""` | no |
| cwlog\_retention\_in\_days | cloudwatch log group retention in days | `string` | `"90"` | no |
| ecs\_execution\_iam\_policy | ecs execution IAM policy | `any` | n/a | yes |
| ecs\_task\_iam\_policy | ecs task IAM policy | `any` | n/a | yes |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| host\_volumes | n/a | `list(map(string))` | `[]` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| service\_role | node type web/admin/api/app | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| td\_container\_definitions | ECS task definition's container definitions | `any` | n/a | yes |
| td\_cpu | ECS task definition cpu mode | `string` | `"1024"` | no |
| td\_memory | ECS task definition memory allocation | `string` | `"2048"` | no |
| td\_network\_mode | ECS task definition network mode | `string` | `"awsvpc"` | no |
| td\_requires\_capabilities | ECS task definition requires compatibilities list | `list` | ```[ "FARGATE" ]``` | no |
| task\_lifecycle\_ignore\_changes | If set to true, the ECS task will have a lifecycle ignore changes block for task definition | `any` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_log\_group\_name | n/a |
| ecs\_task\_definition\_arn | n/a |
| ecs\_task\_definition\_id | n/a |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
