# Hermosa Events Configuration

### General

* Description: Hermosa events configuration.
  This module creates a secret manager configuration for Hermosa events.
* Created By: Zaw Htet
* Module Dependencies:
* Module Components: `hermosa`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-hermosa-events-configuration](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-events-configuration/badge.svg)

### Usage

* Terraform:

```hcl
module "hermosa_events_configuration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/events/configuration?ref=hermosa-events-configuration-v2.0.0"

  env                  = var.env
  env_inst             = var.env_inst
}
```



### Initialization

### Terraform

* Run the hermosa events configuration module in the `hermosa/events/configuration` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── hermosa
          └── events
            └── configuration
                ├── outputs.tf
                ├── secrets.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                             | Options/Defaults         |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat      | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg: 00,01,02,load        | string |    No     | N/A            |

#### Outputs

| Variable Name            | Description  | Type   | Notes |
| :----------------------- | :----------- | :----: | :---- |
| configuration_secret_arn | secret's ARN | string | N/A   |


### Lessons Learned



### References

* [Hermosa Event handlers - Confluence](https://chownow.atlassian.net/l/cp/NZUxPjVe)
