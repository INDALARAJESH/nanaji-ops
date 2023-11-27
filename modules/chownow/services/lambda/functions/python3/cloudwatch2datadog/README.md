# Cloudwatch2Datadog

### General

* Description: Ship CloudWatch logs to Datadog
* Created By: Harry Hahn
* Module Dependencies: `lambda-basic`
* Provider Dependencies: `aws`

![chownow-services-lambda-cloudwatch2datadog](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-lambda-cloudwatch2datadog/badge.svg)

### Usage

* Terraform:

```hcl
module "cloudwatch2datadog" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/cloudwatch2datadog?ref=lambda-cloudwatch2datadog-v2.0.0"

  env = var.env]
}

```

### Initialization

### Terraform

* Run the module in `services` folder
* Example directory structure:
```terraform/environments/uat/us-east-1/services/lambda/functions/python3/cloudwatch2datadog/cloudwatch2datadog.tf
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── lambda
            └── functions
                └── python3
                    └── cloudwatch2datadog
                        └── cloudwatch2datadog.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                     | Options             |  Type  | Required?/Default | Notes |
| :-------------------------------- | :------------------------------ | :------------------ | :----: | :---------------- | :---- |
| env                               | unique environment/stage name   | dev/qa/prod/stg/uat | string | Yes               | N/A   |
| env_inst                          | environment instance            | 00/01               | string | No                | N/A   |
| service                           | service name                    |                     | string | No                | N/A   |
