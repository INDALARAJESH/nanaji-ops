<!-- BEGIN_TF_DOCS -->
# Terraform Lambda Module - Basic - VPC dependencies

## General

* Description: Basic Lambda Module - VPC dependencies
* Created By: Karol Kania
* Terraform Version: 0.14.x

![aws-lambda-basic-vpc-dependencies](https://github.com/ChowNow/ops-tf-modules/workflows/aws-lambda-basic-vpc-dependencies/badge.svg)

The Lambda running within a VPC must have a security group attached. For the moment of writing this module, this was the only requirement -- although the module can be further extended in the future.

Lambda functions by default do not accept any traffic; they are simply invoked via API -- no ingress rules for security groups are necessary.

On the other hand, when associated with an ENI, the Lambda functions running within a VPC can communicate with other services -- the egress rules can be applied.

This module creates a necessary dependency for Lambda when configured to run within a VPC:

- it does not specify any ingress rules (wouldn't be used anyway)
- it specifies a single egress rule to be very universal (allows all outgoing traffic)
- stores the SG id as an output value

The SG id attached to this Lambda function(s) can then be used as an object reference in another SG to allow traffic from.

## Usage

* Terraform:

```hcl
module "lambda_vpc_dependencies" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic-vpc-dependencies?ref=aws-lambda-basic-vpc-dependencies-v2.0.1"

  vpc_name_prefix = var.vpc_name_prefix

  name       = var.name
  env        = local.env
  extra_tags = local.extra_tags
  service    = local.service
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
| name | unique name | `any` | n/a | yes |
| service | unique service name for project/application | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| default\_sg\_id | n/a |
| private\_subnet\_ids | n/a |

## Lessons Learned

## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
