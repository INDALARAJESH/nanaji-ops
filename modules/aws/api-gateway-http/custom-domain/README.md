# Create custom domain, mapping and route53 record for a HTTP API Gateway

### General

* Description: A module to create custom domain, mapping and route53 record for a HTTP API Gateway
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-http-custom-domain](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-http-custom-domain/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "custom-domain" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-http/custom-domain?ref=aws-api-gateway-http-custom-domain-v2.0.0"

  domain        = "dev.svpn.chownow.com"
  subdomain     = "channels"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                    | Options                     | Type   | Required? | Notes |
| :------------ | :---------------------------   | :-------------------------- | :----: | :-------: | :---- |
| domain        | DNS domain name                |                             | string |  Yes      |       |
| subdomain     | DNS subdomain name             |                             | string |  No       |       |


#### Outputs

### Lessons Learned

### References
