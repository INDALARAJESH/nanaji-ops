# LaunchDarkly Pipeline

### General

* Description: Pipeline to ingest LaunchDarkly data
* Created By: Sebastien Plisson
* Module Dependencies: `ec2`
* Provider Dependencies: `aws`

![chownow-services-launchdarkly-pipeline](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-launchdarkly-pipeline/badge.svg)

### Usage

* Terraform:

```hcl
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/launchdarkly-pipeline?ref=launchdarkly-pipeline-v2.0.1"

  env           = var.env

}
```

### Initialization

### Terraform

* Run the launchdarkly-pipeline module in `services` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── launchdarkly-pipeline
            ├── pipeline.tf
            ├── provider.tf
            └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                             | Options             |  Type  | Required?/Default     | Notes |
| :------------ | :-------------------------------------- | :------------------ | :----: | :-------------------- | :---- |
| env           | unique environment/stage name           | dev/qa/prod/stg/uat | string | Yes                   | N/A   |
| service       | service name                            |                     | string | launchdarkly-pipeline | N/A   |
| shard_count   | number of shard for kinesis data stream |                     |  int   | 1                     | N/A   |
