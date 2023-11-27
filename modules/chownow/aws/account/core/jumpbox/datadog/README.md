# Jumpbox Monitor Module

### General

* Description: This module creates a monitor in Datadog for jumpbox instances.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `DataDog/datadog`
* Terraform Version: 1.5.0
* Datadog Provider Version: 3.27.0

![chownow-services-jumpbox-monitor](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-jumpbox-monitor/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "jumpbox_monitor" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/core/jumpbox/datadog?ref=cn-jumpbox-datadog-v3.0.0"
}
```

### Terraform

* Example directory structure: `ops/terraform/datadog/global/jumpbox`
```
├── monitor
│   ├── variables.tf
│   ├── monitor.tf
│   └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume


#### Inputs

| Variable Name           | Description                                       | Options      |  Type  | Required? | Notes |
| :-----------------------| :------------------------------------------------ | :----------- | :----: | :-------: | :---- |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned
