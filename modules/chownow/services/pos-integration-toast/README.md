<!-- BEGIN_TF_DOCS -->
# POS Toast Integration Service

### General

* Description: A module to POS toast integration service
* Created By: Torri Haines, Mike Lane, and Kareem Shahin
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a POS Toast microservice, which integrates Toast with the ChowNow system. The service will be a "proxy" between ChowNow and the Toast API and handle all restaurant traffic for restaurants that use Toast.

### Contributing
Looking to create a lambda for the private REST API? See the [api_lambda submodule](api_lambda/README.md).
Looking to create a lambda for handling messages with SQS? See the [sqs_lambda submodule](sqs_lambda/README.md).
Looking to create a scheduled lambda? See the [scheduled_lambda submodule](scheduled_lambda/README.md).

Once you've made changes to this repository, ensure you update the tag in the example this README and create a PR.  Once the PR is approved and merged, tag this module and push the tag by doing the following:

```sh
# pull the latest on master
$ git checkout master
$ git pull

# tag the module and push the tags - make sure you verify the latest tag in github or this README
$ git tag -f -a pos-integration-toast-v1.2.10 -m '<message with details>'
$ git push --follow-tags
```
Note: make sure you specify the proper tag version.

### Updating Documenation
To keep documentation up to date and to automatically generate variable and output information, we use [terraform-docs](https://terraform-docs.io/user-guide/introduction/). Also see the [guide](https://chownow.atlassian.net/wiki/spaces/CE/pages/2726166529/Terraform+-+Documenting+Service+Modules) on documenting service modules in confluence.

To re-generate the README after updating entries in the respective docs/ folder, simply run the following command from the root directory of the module:
```
terraform-docs -c ~/github/chownow/ops-tf-modules/.tfdocs.d/.terraform-docs.yml --output-file README.md .
```

## Usage

* Terraform:

```hcl
module "pos_toast" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pos-integration-toast?ref=pos-integration-toast-v1.6.6"

  env         = var.env
  env_inst    = var.env_inst
  toast_url   = "https://ws-api.toasttab.com"
  hermosa_url = "https://api.chownow.com"

  # This is the client name for the Toast creds used in this environment
  # Toast requires uppercase name + colon format
  toast_external_id_prefix = "CHOWNOW:"

  # this is ignored and updated via the Github Actions pipeline for the pos-toast-service repo
  lambda_image_tag = "f3eeac9d6"

  source_vpc_endpoint_ids = ["vpce-123456789"]

  enable_dynamo_pitr = true
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_get\_order\_prices\_lambda\_command | the handler command for the get order prices handler | `string` | `"api.restaurants.orders.prices.post.app.handler"` | no |
| api\_get\_restaurant\_errors\_lambda\_command | the command for the get restaurant integration errors api lambda container | `string` | `"api.restaurants.integration_errors.get.app.handler"` | no |
| api\_get\_restaurant\_lambda\_command | the command for the get restaurant api lambda container | `string` | `"api.restaurants.get.app.handler"` | no |
| api\_get\_restaurant\_locations\_lambda\_command | the command for the get restaurant locations api lambda container | `string` | `"api.restaurants.locations.get.app.handler"` | no |
| api\_patch\_restaurant\_lambda\_command | the handler command for the patch restaurant handler | `string` | `"api.restaurants.patch.app.handler"` | no |
| api\_post\_authorization\_url\_lambda\_command | the handler command for the post authorization url handler | `string` | `"api.authorization_url.post.app.handler"` | no |
| api\_post\_order\_lambda\_command | the handler command for the post order handler | `string` | `"api.restaurants.orders.post.app.handler"` | no |
| cloudwatch\_logs\_retention | CloudWatch logs retention in days | `number` | `14` | no |
| datadog\_log\_level | Datadog agent log level | `string` | `"ERROR"` | no |
| enable\_dynamo\_pitr | A boolean value to enable/disable the point\_in\_time\_recovery of the dynamodb resource. | `bool` | `false` | no |
| enable\_dynamo\_stream | A boolean value to enable/disable dynamodb streams. | `bool` | `false` | no |
| enable\_fivetran\_dynamo\_integration | A boolean value to enable/disable fivetran integration with our dynamo streams. This is used by DnA to ingest data from our service. Note: dynamo streams must be enabled | `bool` | `false` | no |
| enable\_lambda\_autoscaling | Whether to enable Application AutoScaling - operates on Provisioned concurrency | `bool` | `false` | no |
| env | unique environment name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| hermosa\_admin\_base\_url | url for hermosa admin | `string` | n/a | yes |
| hermosa\_url | url for hermosa api | `string` | n/a | yes |
| lambda\_autoscaling\_max\_capacity | The max capacity of the scalable target | `number` | `5` | no |
| lambda\_autoscaling\_min\_capacity | The min capacity of the scalable target | `number` | `1` | no |
| lambda\_image\_tag | image tag for the webhook lambdas | `string` | n/a | yes |
| lambda\_memory\_size | amount of memory in MB for lambda function | `number` | `256` | no |
| lambda\_provisioned\_concurrency | Manages a Lambda Provisioned Concurrency Configuration | `number` | `0` | no |
| lambda\_provisioned\_concurrency\_autoscaling\_target | Target utilization of provisioned concurrency in which to trigger autoscaling. For example 0.55 means to scale when 55% of provisioned concurrency is utilized | `number` | `0.55` | no |
| lambda\_timeout | amount of time lambda function has to run in seconds | `number` | `300` | no |
| lambda\_vpc\_id | VPC id for which lambdas that need VPC access will be deployed into | `string` | `""` | no |
| lambda\_vpc\_subnet\_ids | list of subnet ids to launch the lambda into | `list(string)` | `[]` | no |
| menu\_metadata\_checker\_command | the handler command for the menu metadata checker handler | `string` | `"handlers.menu_metadata_checker.handler"` | no |
| resto\_config\_validator\_command | the handler command for the restaurant config validator cron | `string` | `"handlers.restaurant_config_validator.handler"` | no |
| source\_vpc\_endpoint\_ids | Source VPC Endpoint IDS of the VPC that is allowed to interface with the private api gateway | `list(string)` | `[]` | no |
| toast\_external\_id\_prefix | The prefix for external Ids in the Toast API. The value will be the Toast client name. | `string` | n/a | yes |
| toast\_url | url for toast api | `string` | n/a | yes |
| webhook\_allowed\_ip\_ranges | Allow list of IP addresses that can access webhook api gateway. Defaults to cloudflare IPs | `list(string)` | ```[ "173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "141.101.64.0/18", "108.162.192.0/18", "190.93.240.0/20", "188.114.96.0/20", "197.234.240.0/22", "198.41.128.0/17", "162.158.0.0/15", "104.16.0.0/13", "104.24.0.0/14", "172.64.0.0/13", "131.0.72.0/22" ]``` | no |
| webhook\_menu\_lambda\_command | the handler command for the menu event handler container | `string` | `"webhook.menu_handler.app.handler"` | no |
| webhook\_partner\_lambda\_command | the handler command for the partner event handler container | `string` | `"webhook.partner_handler.app.handler"` | no |
| webhook\_processor\_lambda\_command | the handler command for the webhook processor | `string` | `"webhook.webhook_handler.app.handler"` | no |
| webhook\_stock\_lambda\_command | the handler command for the stock event handler container | `string` | `"webhook.stock_handler.app.handler"` | no |

## Outputs

| Name | Description |
|------|-------------|
| key\_arn\_main | n/a |
| kms\_alias\_arn | n/a |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
