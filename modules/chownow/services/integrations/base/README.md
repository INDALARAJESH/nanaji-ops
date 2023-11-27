# Integrations base

### General

* Description: Integrations API Base Terraform Module
* Created By: Tim Ho
* Module Dependencies: `vpc`, `lambda-layer`
* Provider Dependencies: `aws`, `template`

![chownow-services-integrations-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-integrations-base/badge.svg)



### Usage

* Terraform basic:

```hcl

module "integrations_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/integrations/base?ref=cn-integrations-base-v2.1.3"

  env     = var.env
  service = var.service
}
```

eg directory structure

```
uat
├── env_global.tf
├── global
└── us-east-1
    └── services
        └── integrations
            ├── main                   => module_instance_1
            │   ├── app
            │   │   ├── app.tf
            │   │   ├── provider.tf
            │   │   └── variables.tf
            │   └── base
            │       ├── base.tf
            │       ├── provider.tf
            │       └── variables.tf
            ├── addtl                  => module_instance_2
            │   ├── app
            │   │   ├── app.tf
            │   │   ├── provider.tf
            │   │   └── variables.tf
            │   └── base
            │       ├── base.tf
            │       ├── provider.tf
            │       └── variables.tf
            └── shared
                ├── provider.tf
                ├── shared.tf
                └── variables.tf
```

### Initialization

### Terraform

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name          | Description                                    | Options                         |  Type  | Required? | Notes |
| :--------------------- | :--------------------------------------------- | :------------------------------ | :----: | :-------: | :---- |
| env                    | unique environment/stage name                  | sandbox/dev/qa/uat/stg/prod/etc | string |    Yes    | N/A   |
| env_inst               | environment instance number                    | 1...n                           | string |    No     | N/A   |
| hermosa_api_url        | hermosa api url                                | default: ''                     | string |    No     | N/A   |
| service                | name of ECS service                            | default: integrations           | string |    No     | N/A   |
| service_id             | unique service id                              | default: ''                     | string |    No     | N/A   |
| wildcard_domain_prefix | cert domain prefix                             | default: ''                     | string |    No     | N/A   |
| enable_canary          | enable canar ydeployment                       | default: 1                      |  int   |    No     | N/A   |
| wildcard_domain_prefix | cert domain prefix                             | default: ''                     | string |    No     | N/A   |
| traffic_distribution   | key to traffic distribution map                | default: 'blue'                 | string |    No     | N/A   |
| target_group_arn_blue  | allow override to attach existing target group | default: ''                     | string |    No     | N/A   |
| alb_addtl_hosts        | additional host headers to match               | default: []                     |  list  |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |
