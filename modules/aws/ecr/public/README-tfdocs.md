<!-- BEGIN_TF_DOCS -->
# ECR

### General

* Description: Creates an ECR public repo
* Created By: Oliver Reyes
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-ecr-public](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecr-public/badge.svg)

## Usage

* Terraform:

```hcl
module "ecr" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecr/public?ref=aws-ecr-public-v2.0.0"

  env     = var.env
  service = var.service
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_name | custom name for ecr repo | `string` | `""` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| image\_tag\_is\_mutable | The tag mutability setting for the repository | `bool` | `true` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| repo\_arn | n/a |
| repo\_name | n/a |
| repo\_url | n/a |

### Lessons Learned

* Lifecycle policies map one to one with ECR repos
* You can add multiple rules to a single lifecyle policy
* When adjusting the lifecycle rule order, you must also adjust the position of the rules. Otherwise terraform will continue to trigger changes.

### References

* [Terraform ECR Lifecycle Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->