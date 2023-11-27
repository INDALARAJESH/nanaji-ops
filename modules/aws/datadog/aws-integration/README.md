# Datadog AWS Integrations Plugin

### General

* Description: A module to create an AWS Integration role used by datadog
* Created By: Allen Dantes
* Module Dependencies:
  * A datadog API key in secrets manager at: `env/datadog/ops_api_key`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-datadog-integration](https://github.com/ChowNow/ops-tf-modules/workflows/aws-datadog-integration/badge.svg)

### Usage

* Terraform:

* Datadog integration example

```hcl
module "aws_integration" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/aws/datadog/aws-integration?ref=aws-datadog-integration-v2.0.0"

  env                       = var.env
  service                   = var.service
  integration_external_id   = "4sa5d4a7s5d4asd47asd47s" # Obtain this value from Datadog integration page

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                   | Options |  Type  | Required? | Notes |
| :-----------------------| :---------------------------- | :------ | :----: | :-------: | :---- |
| env                     | unique environment/stage name |         | string |    Yes    | N/A   |
| env_inst                | environment instance number   | 1...n   | string |    No     | N/A   |
| service                 | unique service name           |         | string |    Yes    | N/A   |
| integration_external_id | datadog external id           |         | string |    Yes    | N/A   |


#### Outputs


### Lessons Learned
Going through the datadog provider wasn't enough. We didn't get the proper roles to get it working so we went with the cloud templated version to get the right settings.


### References
