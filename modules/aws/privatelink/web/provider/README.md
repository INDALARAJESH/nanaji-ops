# PrivateLink Provider

### General

* Description: A module to create an AWS PrivateLink VPC Endpoint Service Provider
* Created By: Joe Perez
* Module Dependencies:
  * a deployed `alb` module
* Provider Dependencies: `aws`
* Terraform Version: 1.5.x

![aws-privatelink-web-provider](https://github.com/ChowNow/ops-tf-modules/workflows/aws-privatelink-web-provider/badge.svg)

### Usage


* PrivateLink VPC Endpoint Service Provider:

```hcl
module "privatelink_provider" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/provider?ref=aws-privatelink-web-provider-v2.0.2"

  env     = var.env
  service = var.service


  # Provider Variables
  service_provider_alb_name         = "${var.service}-pub-${var.env}"
  service_provider_private_dns_name = "${var.service}.${var.env}.svpn.chownow.com"
  service_provider_vpc_name         = "nc-${var.env}"

}
```
_This should be deployed in a service's `base` module next to its ALB module_


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name   | Description                                        | Options             |  Type  | Required? | Notes |
| :-------------- | :------------------------------------------------- | :------------------ | :----: | :-------: | :---- |
| aws_account_ids | list of account IDs allowed to reach privatelink   |                     |  list  |    Yes    | N/A   |
| env             | unique environment/stage name                      | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst        | iteration of environment                           | eg 00,01,02,etc     | string |    No     | N/A   |
| service         | service name                                       | hermosa, flex, etc  | string |    Yes    | N/A   |
| custom_vpc_name | overrides existing vpc name for resource placement |                     | string |    No     | N/A   |
| vpc_name_prefix | name prefix for vpc for resource placement         | (default: `main`)   | string |    No     | N/A   |

#### Outputs

| Variable Name            | Description              |  Type  | Notes |
| :----------------------- | :----------------------- | :----: | :---- |
| nlb_arn                  | nlb ARN                  | string | N/A   |
| nlb_name                 | nlb name                 | string | N/A   |
| nlb_dns_name             | nlb DNS name             | string | N/A   |
| privatelink_service_name | privatelink service name | string | N/A   |




### Lessons Learned

* You cannot assign security groups to an NLB, security must happen at the next hop
* AWS recommends turning off `enable_cross_zone_load_balancing` when using an ALB as a target
* You cannot change the private DNS if there's an active connection to a consumer VPC endpoint
* You cannot change the number of subnets associated with an existing NLB. Terraform will interpret this as a rebuild, even though AWS added in-place updates as an option. Destroying the NLB fails because it's associated with a VPC Endpoint Serivce :facepalm:
  * You will need to destroy the provider side VPC Endpoint Service to start over.
* Private owned domain validation can be fickle. Sometimes it doesn't work during provisioning, sometimes it doesn't work if you add it to an existing VPC endpoint service, eg:

```bash
Error: Error creating VPC Endpoint: InvalidParameter: Private DNS can't be enabled because the service com.amazonaws.vpce.us-east-1.vpce-svc-0a0103a16bb11c5fc has not verified the private DNS name.
        status code: 400, request id: 0f35e46d-e677-4bac-883d-b539bab21067
```

### References

* [Confluence - AWS PrivateLink](https://chownow.atlassian.net/wiki/spaces/CE/pages/2592964930/AWS+PrivateLink)
* [Originating JIRA Ticket](https://chownow.atlassian.net/browse/OPS-3058)
* [Application Load Balancer-type Target Group for Network Load Balancer](https://aws.amazon.com/blogs/networking-and-content-delivery/application-load-balancer-type-target-group-for-network-load-balancer/)
* [PrivateLink Private DNS](https://cloudnetworks.io/2021-07-24-privatelink_private_dns/)
* [Accessing Private Containers on ECS using PrivateLink](https://lvthillo.com/posts/access-private-containers-on-ecs-using-privatelink/)
* [Confluence - AWS Privatelink](https://chownow.atlassian.net/wiki/spaces/CE/pages/2592964930/AWS+PrivateLink)
