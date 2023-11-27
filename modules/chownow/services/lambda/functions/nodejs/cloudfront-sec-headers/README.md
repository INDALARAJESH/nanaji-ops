# Cloudfront-sec-headers function

### General

* Description: Add security headers
* Created By: Sebastien Plisson
* Module Dependencies: `lambda-basic`
* Provider Dependencies: `aws`

![cn-services-lambda-cloudfront-sec-headers](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-lambda-cloudfront-sec-headers/badge.svg)

### Usage

* Terraform:

```hcl
module "cloudfront_sec_headers" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/nodejs/cloudfront-sec-headers?ref=cn-lambda-cloudfront-sec-headers-v2.0.1"

  env = var.env
}

```

### Initialization

### Terraform

* Run the module in `services` folder
* Example directory structure:
```terraform/environments/uat/us-east-1/services/lambda/functions/nodejs/cloudfront-sec-headers/function.tf
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── lambda
            └── functions
                └── nodejs
                    └── cloudfront-sec-headers
                        └── function.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options             |  Type  | Required?/Default | Notes |
| :------------ | :---------------------------- | :------------------ | :----: | :---------------- | :---- |
| service       | unique service name           | default: cloudfront | string | No                | N/A   |
| env           | unique environment/stage name | dev/qa/prod/stg/uat | string | Yes               | N/A   |
| env_inst      | environment instance number   | 1...n               | string | No                | N/A   |
