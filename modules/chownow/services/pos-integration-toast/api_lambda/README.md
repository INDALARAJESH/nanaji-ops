<!-- BEGIN_TF_DOCS -->
# Toast POS Service API Lambda Module

### General

* Description: A module for creating lambdas that are fronted by the private API gateway that exposes this service.
* Created By: Kareem Shahin
* Providers : `aws`
* Terraform Version: 0.14.x

Note: Ensure that when adding a lambda, you are updating the [OpenAPI](../../templates/private_api.json) spec for the API Gateway in order to include the new route to the lambda resource.

## Usage

* Terraform:

```hcl
module "get_restaurant" {
  source = "./api_lambda"

  service                = local.service
  env                    = local.env
  api_lambda_name        = "get-restaurant"
  api_lambda_image_tag   = var.lambda_image_tag
  lambda_base_policy_arn = aws_iam_policy.lambda_base.arn
  image_repository_url   = local.image_repository_url
  api_gw_execution_arn   = aws_api_gateway_rest_api.private_api.execution_arn

  environment_variables = merge(
    {
      DYNAMODB_TABLE = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL   = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER = var.api_get_restaurant_lambda_command
    },
    local.datadog_env_vars
  )

}

# use the outputs to attach additional policies to the lambda role
resource "aws_iam_role_policy_attachment" "get_restaurant_policy_attachment_dynamo_read" {
  role       = module.get_restaurant.api_lambda_role_name
  policy_arn = aws_iam_policy.get_restaurant_dynamodb_read.arn
}

resource "aws_iam_policy" "get_restaurant_dynamodb_read" {
  name   = "${module.get_restaurant.api_lambda_name}-dynamodb-read-${var.env}"
  policy = data.aws_iam_policy_document.dynamodb_read.json
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_gw\_execution\_arn | The execution ARN of the api gateway required to add a permission to invoke the api lambda | `string` | n/a | yes |
| api\_lambda\_image\_tag | Handler lambda image tag. | `any` | n/a | yes |
| api\_lambda\_name | API lambda name | `any` | n/a | yes |
| cloudwatch\_logs\_retention | CloudWatch logs retention in days | `number` | `14` | no |
| enable\_lambda\_autoscaling | Whether to enable Application AutoScaling - operates on Provisioned concurrency | `bool` | `false` | no |
| env | Env name | `any` | n/a | yes |
| environment\_variables | map of environment variables for the lambda function | `map(string)` | `{}` | no |
| image\_repository\_url | Image repository url | `any` | n/a | yes |
| lambda\_autoscaling\_max\_capacity | The max capacity of the scalable target | `number` | `5` | no |
| lambda\_autoscaling\_min\_capacity | The min capacity of the scalable target | `number` | `1` | no |
| lambda\_base\_policy\_arn | Base AWS IAM policy arn for all service lambdas | `any` | n/a | yes |
| lambda\_memory\_size | amount of memory in MB for lambda function | `number` | `128` | no |
| lambda\_provisioned\_concurrency | Manages a Lambda Provisioned Concurrency Configuration | `number` | `1` | no |
| lambda\_provisioned\_concurrency\_autoscaling\_target | Target utilization of provisioned concurrency in which to trigger autoscaling. For example 0.9 means to scale when 90% of provisioned concurrency is utilized | `number` | `0.9` | no |
| lambda\_timeout | amount of time lambda function has to run in seconds | `number` | `30` | no |
| resource\_path | The resource path used in API GW for the lambda (ex: POST/v1/restaurants, GET/v1/restaurants/{restaurant\_id} | `string` | n/a | yes |
| service | Service name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| api\_lambda\_arn | the arn of the api lambda |
| api\_lambda\_name | the name of the api lambda |
| api\_lambda\_role\_arn | the arn of the api lambda's role |
| api\_lambda\_role\_name | the name of the api lambda's role |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->