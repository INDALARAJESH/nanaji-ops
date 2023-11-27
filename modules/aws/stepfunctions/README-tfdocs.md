<!-- BEGIN_TF_DOCS -->
# Terraform Lambda Module - Basic

## General

* Description: A module to create a step functions state machine
* Created By: Tim Ho, Karol Kania
* Terraform Version: 0.14.x

![aws-stepfunctions](https://github.com/ChowNow/ops-tf-modules/workflows/aws-stepfunctions/badge.svg)

## Usage

* Terraform:

```hcl
module "state_machine" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/stepfunctions?ref=aws-stepfunctions-v2.0.0"

  env                = local.env
  name               = var.name
  service            = var.service
  step_function_name = format("%s-%s-sfn-%s", var.name, var.service, local.env)
  step_function_definition = templatefile(format("%s/templates/sfn-definition.asl.json", path.module), {
    SomeVariableUsedInTemplate = module.reference.output
  })
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| iam\_sqs\_arns | (optional) list of sqs queues arns to r/w access by state machine | `list` | `[]` | no |
| name | unique name | `any` | n/a | yes |
| service | unique service name for project/application | `any` | n/a | yes |
| step\_function\_definition | json-formatted step function definition | `any` | n/a | yes |
| step\_function\_name | step function name | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| tracing\_enabled | whether to enable tracing for step functions | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| sfn\_iam\_role\_name | n/a |
| sfn\_state\_machine\_arn | n/a |

## Lessons Learned

## References

[Amazon States Language](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->