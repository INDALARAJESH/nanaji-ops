# Messages Pipeline

### General

* Description: Pipeline to ingest messages of a specific SNS topic
* Created By: Mike Tsui
* Module Dependencies:
* Provider Dependencies: `aws`

![chownow-services-messages-pipeline](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-messages-pipeline/badge.svg)

### Usage

* Terraform:

```hcl
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/messages/pipeline?ref=cn-messages-pipeline-v2.0.1"

  env             = var.env
  service         = "order"
  topic_base_name = "cn-order-events"

}
```

### Initialization

### Terraform

* Run the messages-pipeline module in `services` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── messages
            └── order
                └── pipeline
                    ├── main.tf
                    ├── provider.tf
                    └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name   | Description                             | Options             |  Type  | Required?/Default     | Notes |
| :-------------- | :-------------------------------------- | :------------------ | :----: | :-------------------- | :---- |
| env             | unique environment/stage name           | dev/qa/prod/stg/uat | string | Yes                   | N/A   |
| env_inst        | environment instance                    | 00/01/02/03/load    | string | No/""                 | N/A   |
| service         | service name                            |                     | string | Yes                   | N/A   |
| topic_arn       | SNS topic ARN                           |                     | string | No/""                 | N/A   |
| topic_base_name | SNS topic base name                     |                     | string | Yes                   | N/A   |
