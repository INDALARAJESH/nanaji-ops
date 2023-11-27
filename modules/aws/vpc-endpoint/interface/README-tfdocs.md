<!-- BEGIN_TF_DOCS -->
# Interface VPC Endpoint

A VPC endpoint enables you to securely connect your VPC to another service.

There are three types of VPC endpoints – Interface endpoints, Gateway Load Balancer endpoints, and gateway endpoints.

Interface endpoints and Gateway Load Balancer endpoints are powered by AWS PrivateLink, and use an elastic network interface (ENI) as an entry point for traffic destined to the service.

Interface endpoints are typically accessed using the public or private DNS name associated with the service, while gateway endpoints and Gateway Load Balancer endpoints serve as a target for a route in your route table for traffic destined for the service.

[AWS services that integrate with AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/integrated-services-vpce-list.html)

![aws-vpce-interface](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpce-interface/badge.svg)

## General

* Description: AWS Interface VPC Endpoint Module
* Created By: Karol Kania
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

## Usage

* Terraform:

```hcl
module "vpce_interface_api_gw" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v1.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = format("%s-%s", var.vpc_name_prefix, local.env)
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Name of AWS env | `any` | n/a | yes |
| env\_inst | AWS environment instance count | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| name | Easily identifiable name for tagging | `string` | n/a | yes |
| service\_name | The service that you are connecting to (i.e. ec2 or execute-api) | `string` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_tag\_name | tag:Name for the VPC where the endpoint will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpce\_id | n/a |

## Lessons Learned

## References

* [AWS Docs - Interface VPC endpoints (AWS PrivateLink)](https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html)
* [AWS Docs - API Gateway Private API](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->