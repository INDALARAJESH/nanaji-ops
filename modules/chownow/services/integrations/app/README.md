# Integrations App

### General

* Description: Integrations API App Terraform Module
* Created By: Tim Ho
* Module Dependencies: `vpc`, `lambda-layer`
* Provider Dependencies: `aws`, `template`

![chownow-services-integrations-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-integrations-app/badge.svg)



### Usage

* Terraform basic:

```hcl

module "integrations_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/integrations/base?ref=cn-integrations-app-v2.1.5"

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
            ├── main
            │   ├── app-blue
            │   │   ├── app.tf
            │   │   ├── provider.tf
            │   │   └── variables.tf
            │   ├── app-green
            │   │   ├── app.tf
            │   │   ├── provider.tf
            │   │   └── variables.tf
            │   └── base
            │       ├── base.tf
            │       ├── provider.tf
            │       └── variables.tf
            ├── sandbox
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

| Variable Name                                        | Description                         | Options                         |  Type  | Required? | Notes |
| :--------------------------------------------------- | :---------------------------------- | :------------------------------ | :----: | :-------: | :---- |
| env                                                  | unique environment/stage name       | sandbox/dev/qa/uat/stg/prod/etc | string |    Yes    | N/A   |
| env_inst                                             | environment instance number         | 1...n                           | string |    No     | N/A   |
| service                                              | name of ECS service                 | default: integrations           | string |    No     | N/A   |
| service_id                                           | unique service id                   | default: ''                     | string |    No     | N/A   |
| domain_public                                        | public domain                       | default: 'svpn.chownow.com'     | string |    No     | N/A   |
| deployment_suffix                                    | used to name blue/green deployments | default: ''                     | string |    No     | N/A   |
| vpc_name_prefix                                      | vpc name prefix                     | default: 'nc'                   | string |    No     | N/A   |
| web_ecr_repository_uri                               |                                     |                                 | string |    No     | N/A   |
| web_container_image_version                          | web container image tag             |                                 | string |    No     | N/A   |
| web_container_integrator_request_rate                |                                     |                                 | string |    No     | N/A   |
| web_container_log_level                              |                                     |                                 | string |    No     | N/A   |
| web_container_port                                   |                                     |                                 | string |    No     | N/A   |
| web_container_is_sandbox                             |                                     |                                 | string |    No     | N/A   |
| web_container_restaurants_locations_rate             |                                     |                                 | string |    No     | N/A   |
| web_container_restaurants_orders_list_burst_rate     |                                     |                                 | string |    No     | N/A   |
| web_container_restaurants_orders_list_sustained_rate |                                     |                                 | string |    No     | N/A   |
| web_container_restaurants_orders_rate                |                                     |                                 | string |    No     | N/A   |
| web_container_user_request_rate                      |                                     |                                 | string |    No     | N/A   |
| web_container_xff_proxy_depth                        |                                     |                                 | string |    No     | N/A   |
| web_ecs_service_desired_count                        |                                     |                                 |  int   |    No     | N/A   |
| web_ecs_service_max_count                            |                                     |                                 |  int   |    No     | N/A   |

See more variables in ecs_variables.tf

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |
