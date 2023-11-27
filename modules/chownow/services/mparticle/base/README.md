# MParticle Base

### General

* Description: MParticle base terraform module. This module creates mparticle quarantine bucket which is used by Matillion and the data team. It also creates the service acount for mparticle to invoke a lambda
* Created By: Joe Perez
* Module Dependencies: N/A
* Module Components: `quarantine bucket`, `iam user`, `ecr`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-mparticle-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-mparticle-base/badge.svg)

### Usage

* Terraform:

```hcl
module "mparticle_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/mparticle/base?ref=chownow-services-mparticle-app-v2.0.0"

  env = var.env
}
```



### Initialization

### Terraform

* Run the mparticle base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── mparticle
            └── base
                ├── mparticle_base.tf
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

* MParticle requires you to use their s3 bucket prefix name to integrate into their system
* MParticle requires you to use their lambda prefix "mpr" to integrate into their system (reasoning unknown)


### References

* [mparticle s3 bucket](https://docs.mparticle.com/integrations/amazons3/event/)
* [mparticle rules](https://docs.mparticle.com/guides/platform-guide/rules/)
