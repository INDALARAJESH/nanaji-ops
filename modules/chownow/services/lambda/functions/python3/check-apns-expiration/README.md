# Bastion

### General

* Description: Check APNS Expiration Lambda Module
* Created By: Sebastien Plisson
* Module Dependencies: `lambda-basic`
* Provider Dependencies: `aws`

![chownow-services-lambda-check-apns-expiration](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-lambda-check-apns-expiration/badge.svg)

### Usage

* Terraform:

```hcl
module "check_apns_expiration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/check-apns-expiration?ref=lambda-check-apns-expiration-v2.0.1"

  env = var.env
  platform_application_arns = ["arn:aws:sns:us-east-1:851526424910:app/APNS_SANDBOX/ChowNowiOSDiscover-uat"]
}

```

### Initialization

### Terraform

* Run the module in `services` folder
* Example directory structure:
```terraform/environments/uat/us-east-1/services/lambda/functions/python3/check-apns-expiration/check_apns_expiration.tf
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── lambda
            └── functions
                └── python3
                    └── check-apns-expiration
                        └── check_apns_expiration.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                     | Options             |  Type  | Required?/Default | Notes |
| :-------------------------------- | :------------------------------ | :------------------ | :----: | :---------------- | :---- |
| env                               | unique environment/stage name   | dev/qa/prod/stg/uat | string | Yes               | N/A   |
| platform_application_arns         | list of arns of platform application     |            | list   | Yes               | N/A   |
