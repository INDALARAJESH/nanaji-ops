<!-- BEGIN_TF_DOCS -->
# Terraform REST API Gateway - Private - built using Swagger / OpenAPI spec

## General

* Description: A module to create a Private REST API Gateway using Swagger / OpenAPI spec
* Created By: Sebastien Plisson, Karol Kania
* Module Dependencies: `vpc-endpoint/interface`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-rest-gateway-private-openapi](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-gateway-private-openapi/badge.svg)

## VPC Endpoint Interface(s)

Create an interface VPC endpoint for API Gateway and associate it with your Private API Gateway.

The API Gateway component service for API execution is called `execute-api`. To access your private API once it's deployed, you need to create an interface VPC endpoint for it in your VPC.

After you've created your VPC endpoint, you can use it to access multiple private APIs.

In order to use it, one should associate a VPC endpoint with a private REST API.

Assuming you want to interconnect two different VPCs (so the traffic doesn't leave the AWS network), you should operate on the VPC Endpoints level.

In order to properly set up and secure the Private API Gateway between two interconnected VPCs:

 - create the VPC Endpoint interface and associate it with the Private API Gateway in `VPC-A`
 - create the VPC Endpoint interface in `VPC-B`
 - restrict access to VPC Endpoint from `VPC-B` in resource policy on Private API Gateway in `VPC-A` -- see below

## NOTE for API GW Resource Policy

Resource Policy is **REQUIRED** for `PRIVATE` Api Gateway

***Important***

To restrict access to specific VPC endpoints, you must include `aws:SourceVpce` conditions in your API's resource policy.
If your policy does not include any of these conditions, your API will be accessible by all VPCs.

The module is predefined with the resource policy filtering the incoming traffic to drop all the traffic unless it's coming from the provided `source_vpc_endpoint_ids`

## Usage

* Terraform:

```hcl
/*
  App Module
*/
module "rest_api_gateway_openapi_private" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway-private-openapi?ref=aws-api-gateway-rest-gateway-private-openapi-v2.0.1"

  name       = format("%s-private", local.app_name)
  env        = var.env
  env_inst   = var.env_inst
  extra_tags = local.extra_tags

  # these are used for resource policy for this private api gw
  source_vpc_endpoint_ids = [
    data.aws_vpc_endpoint.api_gw_private_vpce_main.id,
    data.aws_vpc_endpoint.api_gw_private.id
  ]

  # This is used for the VPC Endpoint interface to be associated with the API GW
  vpc_endpoint_ids = [data.aws_vpc_endpoint.api_gw_private.id]

  # this apigw-spec.json is already jsonencoded()
  openapi_spec_json = templatefile(format("%s/templates/apigw.all.json", path.module), {
    api-lambda-invoke-arn = coalesce(
      module.lambda_api.lambda_function_invoke_arn_alias_newest,
      module.lambda_api.lambda_function_invoke_arn
    )
  })
}


/*
  Base Module
*/
module "vpce_interface_api_gw" {
  /*
    This VPC Endpoint interface is associated with the API Gateway
  */
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v2.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = format("%s-%s", var.vpc_name_prefix, local.env)
}

module "vpce_interface_api_gw_vpc_main" {
  /*
    This VPC Endpoint interface is configured in the interconnected VPC and used in the Target Private API Gateway's Resource Policy as the `sourceVpce` filter
  */
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/interface?ref=aws-vpce-interface-v2.0.0"

  env          = var.env
  env_inst     = var.env_inst
  service_name = "execute-api"
  name         = local.app_name

  vpc_tag_name = var.env == "qa" ? local.env : format("%s-%s", "main", local.env)
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                       | Description                                                                                                        | Type           | Default       | Required |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------ | -------------- | ------------- | :------: |
| env                        | unique environment/stage name                                                                                      | `any`          | n/a           |   yes    |
| env\_inst                  | environment instance, eg 01 added to stg01                                                                         | `string`       | `""`          |    no    |
| extra\_tags                | optional addition for tags                                                                                         | `map`          | `{}`          |    no    |
| name                       | name of API gateway                                                                                                | `any`          | n/a           |   yes    |
| openapi\_spec\_json        | JSON-encoded OpenAPI spec with x-amazon-apigateway-integration extensions                                          | `string`       | n/a           |   yes    |
| source\_vpc\_endpoint\_ids | Set of VPC Endpoint identifiers. Used by private API GWs resource policy / filter to explicitly allow traffic from | `list(string)` | n/a           |   yes    |
| tag\_managed\_by           | what created resource to keep track of non-IaC modifications                                                       | `string`       | `"Terraform"` |    no    |
| vpc\_endpoint\_ids         | Set of VPC Endpoint identifiers. Used by private API GWs to be reachable at                                        | `list(string)` | n/a           |   yes    |

## Outputs

| Name                                | Description                                                                                                         |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| api\_gw\_resource\_policy\_checksum | Checksum of API Gateway Resource policy                                                                             |
| api\_id                             | id of api gateway forcing the rest\_api\_policy to be created before deployment                                     |
| openapi\_spec\_checksum             | Checksum of OpenAPI specification that defines the set of routes and integrations to create as part of the REST API |

## Lessons Learned

- Configuring the `/{proxy+}` resource on API GW is convenient to simply pass the traffic to the application, but the application is then entirely exposed and must handle the filtering itself, even for wrong requests
- It's much less error-prone to construct the resource tree (endpoints and methods) using OpenAPI which is much easier to read and see the diffs when it's stored in a version control system -- especially when using the application frameworks that allow generating this spec automatically
  - when compared to terraform way -- especially when building a resource tree that would filter the incoming traffic (endpoints and methods)

## References

[Configuring a REST API using OpenAPI](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
