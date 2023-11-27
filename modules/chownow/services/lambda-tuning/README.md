# Lambda Tuning Service

### General

* Description: A module for tuning lambdas and determining optimal RAM provisioning
* Created By: Dean Rabinowitz
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

[AWS Documentation](https://docs.aws.amazon.com/lambda/latest/operatorguide/profile-functions.html)

[Onboarding Service Example](https://chownow.atlassian.net/wiki/spaces/MOB/pages/2836235353/Onboarding+Service+Lambda+Tuning)

### Usage

* Terraform:

* Lambda Tuning App Example (`lambda_tuning_app.tf`):

```hcl
module "lambda_tuning_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda-tuning/app?ref=lambda-tuning-v2.0.0"
}
```

_Note:_
  - Tuning modules should typically only be deployed in the dev environment
  - DO NOT perform tuning in production unless absolutely required


### Terraform

* Example directory structure:
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── lambda-tuning
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── lambda_tuning.tf
            │   └── provider.tf
```
