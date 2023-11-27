# PrivateLink Consumer

### General

* Description: A module to create an AWS PrivateLink VPC Endpoint Consumer configuration
* Created By: Joe Perez
* Module Dependencies:
  * A deployed `aws-privatelink-web-provider` for a given service
* Provider Dependencies: `aws`
* Terraform Version: 1.5.x

![aws-privatelink-web-consumer](https://github.com/ChowNow/ops-tf-modules/workflows/aws-privatelink-web-consumer/badge.svg)


```bash
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── service-a
            ├── app
            ├── base
            └── privatelink
                 └── consumer
```

### Usage


* PrivateLink Consumer:

```hcl
locals {
  deployments = {
    qa = {
      env                       = "qa"
      env_inst                  = ""
      service_consumer_vpc_name = "qa"
      service_provider_name     = "com.amazonaws.vpce.us-east-1.vpce-svc-090efea1234567890"
    },
    main-qa = {
      env                       = "qa"
      env_inst                  = ""
      service_consumer_vpc_name = "main-qa"
      service_provider_name     = "com.amazonaws.vpce.us-east-1.vpce-svc-090efea1234567890"
    },
    nc-qa = {
      env                       = "qa"
      env_inst                  = ""
      service_consumer_vpc_name = "nc-qa"
      service_provider_name     = "com.amazonaws.vpce.us-east-1.vpce-svc-090efea1234567890"
    },
    qa00 = {
      env                       = "qa"
      env_inst                  = "00"
      service_consumer_vpc_name = "qa00"
      service_provider_name     = "com.amazonaws.vpce.us-east-1.vpce-svc-090efea1234567890"
    },
  }
}


module "privatelink_consumer" {
    source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/privatelink/web/consumer?ref=aws-privatelink-web-consumer-v2.0.2"

    for_each = local.deployments

    env                       = each.value.env
    env_inst                  = each.value.env_inst
    service                   = var.service
    service_consumer_vpc_name = each.value.service_consumer_vpc_name
    service_provider_name     = each.value.service_provider_name
}

```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name             | Description                                | Options             |  Type  | Required? | Notes |
| :------------------------ | :----------------------------------------- | :------------------ | :----: | :-------: | :---- |
| env                       | unique environment/stage name              | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst                  | iteration of environment                   | eg 00,01,02,etc     | string |    No     | N/A   |
| service                   | service name                               | hermosa, flex, etc  | string |    Yes    | N/A   |
| service_consumer_vpc_name | VPC to attach to service provider          |                     | string |    No     | N/A   |
| service_provider_name     | The Provider VPC's Endpoint Service name   |                     | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |





### Lessons Learned

* To use private DNS names on the consumer side, you need to turn on "Enable DNS Hostnames" and "Enable DNS Support" on consumer's VPC

### References

* [Application Load Balancer-type Target Group for Network Load Balancer](https://aws.amazon.com/blogs/networking-and-content-delivery/application-load-balancer-type-target-group-for-network-load-balancer/)
* [PrivateLink Private DNS](https://cloudnetworks.io/2021-07-24-privatelink_private_dns/)
* [Accessing Private Containers on ECS using PrivateLink](https://lvthillo.com/posts/access-private-containers-on-ecs-using-privatelink/)
* [Confluence - AWS Privatelink](https://chownow.atlassian.net/wiki/spaces/CE/pages/2592964930/AWS+PrivateLink)
