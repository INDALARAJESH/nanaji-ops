# Menu Images

### General

* Description: Menu Images terraform module
* Created By: Allen Dantes
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-menu-images-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-menu-images-base/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "menu_images" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/menu-images?ref=cn-menu-images-v2.0.4"

  env      = var.env
  service  = var.service
  zone_id  = data.aws_route53_zone.chownowcdn_dot_com.zone_id
}
```

### Initialization


### Terraform

* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── menu-images
             ├── data_source.tf
             ├── iam.tf
             ├── route53.tf
             ├── s3.tf
             ├── s3_variables.tf
             ├── variables.tf
```

### Inputs

| Variable Name | Description                   | Options                  |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :----------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | dev/qa/prod/stg/uat/data | string |    Yes    | N/A   |
| env_inst      | env instance                  |                          | string |    No     | N/A   |
| service       | service name                  | menu-images              | string |    Yes    | N/A   |

### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### Resources
