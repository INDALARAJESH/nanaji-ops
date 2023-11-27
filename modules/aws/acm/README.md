# Create Certificate

### General

* Description: A module to create a certificate in ACM
* Created By: Joe Perez
* Module Dependencies: `aws-global-base` or `aws-core-base`
  * A public route53 zone for certificate validation
  * A CAA record in that route53 zone for certificate creation authorization
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-acm-wildcard](https://github.com/ChowNow/ops-tf-modules/workflows/aws-acm-wildcard/badge.svg)

### Usage

* Terraform:

* Wildcard cert example
```hcl
module "wildcard_svpn_cert" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/acm/wildcard?ref=aws-acm-wildcard-v2.0.0"

  env           = "sb"
  dns_zone_name = "sb.svpn.chownow.com"

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                     | Type   | Required? | Notes |
| :------------ | :---------------------------  | :-------------------------- | :----: | :-------: | :---- |
| dns_zone_name | name of public route53 zone   |                             | string |  Yes      |       |
| env           | unique environment/stage name |                             | string |  Yes      | N/A   |
| env_inst      | environment instance number   | 1...n                       | string |  No       | N/A   |


#### Outputs



### Lessons Learned
* CAA records need to exist in the local route53 DNS Zone!!!
* You need to make sure there are forwarders in the production account to point to the account you're working in!
* Certificate validation in the AWS Console and Terraform can take more than 30 minutes!!!

### References
