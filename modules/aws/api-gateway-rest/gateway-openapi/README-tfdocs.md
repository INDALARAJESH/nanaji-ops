<!-- BEGIN_TF_DOCS -->
# Terraform REST API Gateway - built using Swagger / OpenAPI spec

## General

* Description: A module to create a REST API Gateway using Swagger / OpenAPI spec
* Created By: Sebastien Plisson, Karol Kania
* Module Dependencies: ``
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

You can use API Gateway to import a REST API from an external definition file into API Gateway. Currently, API Gateway supports OpenAPI v2.0 and OpenAPI v3.0

![aws-api-gateway-rest-gateway-openapi](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-gateway-openapi/badge.svg)

## Usage

* Terraform:

```hcl
module "rest_api_gateway_openapi_public" {
  source     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway-openapi?ref=aws-api-gateway-rest-gateway-openapi-v2.0.1"
  name       = format("%s-public", local.app_name)
  env        = var.env
  env_inst   = var.env_inst
  extra_tags = local.extra_tags

  # this apigw-spec.json is already jsonencoded()
  openapi_spec_json = templatefile(format("%s/templates/apigw.all.json", path.module), {
    api-lambda-invoke-arn = coalesce(
      module.lambda_api.lambda_function_invoke_arn_alias_newest,
      module.lambda_api.lambda_function_invoke_arn
    )
  })
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                                                | Description                                                                    | Type        | Default       | Required |
| --------------------------------------------------- | ------------------------------------------------------------------------------ | ----------- | ------------- | :------: |
| env                                                 | unique environment/stage name                                                  | `any`       | n/a           |   yes    |
| env\_inst                                           | environment instance, eg 01 added to stg01                                     | `string`    | `""`          |    no    |
| extra\_tags                                         | optional addition for tags                                                     | `map`       | `{}`          |    no    |
| name                                                | name of API gateway                                                            | `any`       | n/a           |   yes    |
| openapi\_spec\_json                                 | JSON-encoded OpenAPI spec with x-amazon-apigateway-integration extensions      | `string`    | n/a           |   yes    |
| resource\_policy\_enabled                           | Whether to enable Resource Policy for this API Gateway                         | `bool`      | `false`       |    no    |
| resource\_policy\_source\_ip\_or\_cidr\_block\_list | List of source IP or CIDR blocks - to be used by resource policy -- Allow rule | `list(any)` | `[]`          |    no    |
| tag\_managed\_by                                    | what created resource to keep track of non-IaC modifications                   | `string`    | `"Terraform"` |    no    |

## Outputs

| Name                    | Description                                                                                                         |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------- |
| api\_id                 | id of api gateway                                                                                                   |
| openapi\_spec\_checksum | Checksum of OpenAPI specification that defines the set of routes and integrations to create as part of the REST API |

## Lessons Learned

- Configuring the `/{proxy+}` resource on API GW is convenient to simply pass the traffic to the application, but the application is then entirely exposed and must handle the filtering itself, even for wrong requests
- It's much less error-prone to construct the resource tree (endpoints and methods) using OpenAPI which is much easier to read and see the diffs when it's stored in a version control system -- especially when using the application frameworks that allow generating this spec automatically
  - when compared to terraform way -- especially when building a resource tree that would filter the incoming traffic (endpoints and methods)

## References

[Configuring a REST API using OpenAPI](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
