# Create a Channels api

### General

* Description: A module to create a Channels api
* Created By: Sebastien Plisson
* Module Dependencies:
  * `` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-rest-api-gateway](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-rest-api-gateway/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "channels-rest-api-gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/chownow-services-rest-api-gateway?ref=rest-api-gateway-v2.0.0"

  env                = "dev"
  name               = "channels"
  domain             = "dev.chownowapi.com"
  subdomain          = "channels"

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                 | Options |  Type  | Required? | Notes |
| :------------ | :-------------------------- | :------ | :----: | :-------: | :---- |
| name          | name of api gateway         |         | string |    No     |       |
| domain        | DNS domain name             |         | string |    Yes    |       |
| subdomain     | DNS subdomain name          |         | string |    Yes    |       |
| env           | unique environment name     |         | string |    Yes    | N/A   |
| env_inst      | environment instance number | 1...n   | string |    No     | N/A   |
| extra_tags    | additional tags             |         |  map   |    No     | N/A   |

#### Outputs

### Lessons Learned

### References
