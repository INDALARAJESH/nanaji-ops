# Sysdig Secure - ECS Fargate Orchestrator Agent

### General

* Description: This module can be used to set up an ECS Fargate Orchestrator Agent for Sysdig Secure.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `N/A`
* Provider Dependencies: `aws`
* Terraform Version: ~> 1.5.0
* AWS Provider Version: ~> 5.0.1

![chownow-services-sysdig-secure-ecs-orchestrator](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-sysdig-secure-ecs-orchestrator/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "fargate_orchestrator_agent_main_dev" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/sysdig-secure/ecs/orchestrator?ref=cn-sysdig-secure-ecs-orchestrator-v3.0.2"

  env = var.env
  vpc = "main-dev"
}
```


### Terraform

* Example directory structure: `ops/terraform/environments/dev/us-east-1/services/sysdig-secure/
```
├── ecs
│   ├── env_global.tf -> ../../../../env_global.tf
│   ├── sysdig_secure_orchestrator.tf
│   ├── variables.tf
│   └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                   | Options         |  Type  | Required? | Notes |
| :-----------------------| :---------------------------- | :-----------    | :----: | :-------: | :---- |
| env                     | unique environment/stage name | ex: "dev"       | string | Yes       | N/A   |
| vpc                     | vpc name                      | ex: "main-dev"  | string | Yes       | N/A   |



#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



