# PrivateLink Web Base

### General

* Description: A module to create an AWS PrivateLink configuration between two VPCs in the same or different account using multiple AWS providers
* Created By: Joe Perez
* Module Dependencies:
  * `core-base`
  * a deployed `alb` module
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-privatelink-web-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-privatelink-web-base/badge.svg)

### Usage


* PrivateLink Base (lower environment):

`provider.tf`
```hcl
terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-ENV"
    key    = "ENV/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }
  required_version = ">= 0.14.6"
}



provider "aws" {

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  alias  = "service_consumer"
  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace = "ops/terraform/environments/ENV/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base"
    }
  }
}


provider "aws" {

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  alias  = "service_provider"
  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace = "ops/terraform/environments/ENV/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base"
    }
  }
}

```
_Note: Be sure to change SERVICENAMEGOESHERE with your actual service name and ENV with the actual environment_


`privatelink_base.tf`
```hcl
module "privatelink_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/base?ref=aws-privatelink-web-base-v2.0.5"

  providers = {
    aws.service_consumer = aws.service_consumer
    aws.service_provider = aws.service_provider
  }

  env     = var.env
  service = var.service


  # Provider Variables
  service_provider_alb_name         = "${var.service}-pub-${var.env}"
  service_provider_private_dns_name = "${var.service}.${var.env}.svpn.chownow.com"
  service_provider_vpc_name         = "nc-${var.env}"


  # Consumer Variables
  service_consumer_vpc_name = "main-${var.env}"
}

```



* PrivateLink Base  (production):

`provider.tf`
```hcl
terraform {
  backend "s3" {
    bucket = "chownow-terraform-remote-state-v4-prod"
    key    = "ncp/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }
  required_version = ">= 0.14.6"
}



provider "aws" {

  assume_role {
    role_arn     = "arn:aws:iam::CONSUMERACCOUNTNUMBER:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  alias  = "service_consumer"
  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace = "ops/terraform/environments/CONSUMERENV/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base"
    }
  }
}


provider "aws" {

  assume_role {
    role_arn     = "arn:aws:iam::PROVIDERACCOUNTNUMBER:role/${var.aws_assume_role_name}"
    session_name = "terraform"
  }

  alias  = "service_provider"
  region = "us-east-1"

  default_tags {
    tags = {
      TFWorkspace = "ops/terraform/environments/CONSUMERENV/us-east-1/services/SERVICENAMEGOESHERE/privatelink/base"
    }
  }
}

```
_Note: Be sure to change SERVICENAMEGOESHERE with your actual service name and ENV with the actual environment_


`privatelink_base.tf`
```hcl
module "privatelink_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/base?ref=aws-privatelink-web-base-v2.0.3"

  providers = {
    aws.service_consumer = aws.service_consumer
    aws.service_provider = aws.service_provider
  }

  env             = var.env
  service         = var.service


  # Provider Variables
  service_provider_alb_name         = "${var.service}-pub-${var.env}"
  service_provider_aws_account_ids  = ["731031120404", "851526424910"]
  service_provider_private_dns_name = "${var.service}.${var.env}.svpn.chownow.com"
  service_provider_vpc_name         = "main-ncp"


  # Consumer Variables
  service_consumer_vpc_name = "prod"
}
```
_Note: The biggest differences between prod amd non-prod environments is the `aws_account_ids` parameter and `role_arn` account numbers in the `assume_role` stanza in the provider block. The `aws_account_ids` parameter allow connectivity between VPCs in different AWS accounts._


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                                                                        | Options             |  Type  | Required? | Notes |
| :-------------------------------- | :--------------------------------------------------------------------------------- | :------------------ | :----: | :-------: | :---- |
| env                               | unique environment/stage name                                                      | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst                          | iteration of environment                                                           | eg 00,01,02,etc     | string |    No     | N/A   |
| service                           | service name                                                                       | hermosa, menu, etc  | string |    Yes    | N/A   |
| service_consumer_vpc_name         | which VPC to use for resource placement on consumer vpc side                       |                     | string |    Yes    | N/A   |
| service_provider_aws_account_ids  | list of account IDs allowed to reach privatelink when using different aws accounts |                     |  list  |    Yes    | N/A   |
| service_provider_alb_name         | name of ALB to attach VPC Endpoint service to                                      |                     | string |    No     | N/A   |
| service_provider_private_dns_name | DNS name for service on provider VPC side                                          | DNS Name            | string |    Yes    | N/A   |
| service_provider_vpc_name         | which VPC to use for resource placement on provider vpc side                       |                     | string |    Yes    | N/A   |

#### Outputs

| Variable Name            | Description              |  Type  | Notes |
| :----------------------- | :----------------------- | :----: | :---- |
| nlb_arn                  | nlb ARN                  | string | N/A   |
| nlb_name                 | nlb name                 | string | N/A   |
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
