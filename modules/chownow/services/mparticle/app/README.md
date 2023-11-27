# MParticle app

### General

* Description: MParticle app terraform module. This module creates mparticle quarantine bucket which is used by Matillion and the data team
* Created By: Joe Perez
* Module Dependencies: N/A
* Module Components: `iterable rules lambda`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-mparticle-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-mparticle-app/badge.svg)

### Usage

* Terraform:

```hcl
module "mparticle_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/mparticle/app?ref=chownow-services-mparticle-app-v2.0.0"

  env = var.env
}
```



### Initialization

### Terraform

* Run the mparticle app module in `app` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── mparticle
            └── app
                ├── mparticle_app.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                  |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :----------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | dev/qa/prod/stg/uat/data | string |    Yes    | N/A   |
| env_inst      | iteration of environment      | eg 00,01,02,etc          | string |    No     | N/A   |
| service       | service name                  | mparticle                | string |    No     | N/A   |


#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References
