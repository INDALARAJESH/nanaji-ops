<!-- BEGIN_TF_DOCS -->
# Terraform REST API Gateway - deployment

## General

* Description: A module to trigger deployment of an API Gateway to a predefined stage
* Created By: Karol Kania
* Module Dependencies: ``
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-rest-deployment](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-deployment/badge.svg)

## Usage

* Terraform:

```hcl
module "rest_api_gateway_openapi_private_deployment" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/deployment?ref=aws-api-gateway-rest-deployment-v2.0.1"

  env      = var.env
  env_inst = var.env_inst

  api_id              = module.rest_api_gateway_openapi_private.api_id
  create_api_key      = var.create_api_key
  access_log_settings = local.access_log_settings

  redeployment_trigger = [
    module.rest_api_gateway_openapi_private.openapi_spec_checksum,
    module.rest_api_gateway_openapi_private.api_gw_resource_policy_checksum
  ]

  extra_tags = local.extra_tags
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                  | Description                                                  | Type                                                          | Default       | Required |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------- | ------------- | :------: |
| access\_log\_settings | Cloudwatch access log settings                               | `list(object({ destination_arn = string, format = string }))` | n/a           |   yes    |
| api\_id               | ID of REST API gateway                                       | `any`                                                         | n/a           |   yes    |
| create\_api\_key      | provides an API Gateway API Key                              | `bool`                                                        | n/a           |   yes    |
| env                   | unique environment name                                      | `any`                                                         | n/a           |   yes    |
| env\_inst             | environment instance, eg 01 added to stg01                   | `string`                                                      | `""`          |    no    |
| extra\_tags           | optional addition for tags                                   | `map`                                                         | `{}`          |    no    |
| redeployment\_trigger | value                                                        | `list`                                                        | `[]`          |    no    |
| tag\_managed\_by      | what created resource to keep track of non-IaC modifications | `string`                                                      | `"Terraform"` |    no    |

## Outputs

| Name                 | Description |
| -------------------- | ----------- |
| default\_stage\_name | n/a         |

## Lessons Learned

## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
