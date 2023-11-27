# Discover Base Module

### General

* Description: Discover base terraform module.
* Created By: Sebastien Plisson
* Module Dependencies:
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-discover-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-discover-base/badge.svg)


### Usage

* Terraform (basic):

```hcl
module "discover_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/discover/base?ref=cn-discover-base-v2.0.0"

  env      = "qa"
  env_inst = "04"
}
```

### Initialization

### Terraform

* Run the Discover base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── discover
            └── base
                ├── discover_base.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                               | Options             |  Type  | Required? | Notes          |
| :---------------------------- | :---------------------------------------- | :------------------ | :----: | :-------: | :------------- |
| env                           | unique environment/stage name             | dev/qa/prod/stg/uat | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                  | eg 00,01,02,etc     | string |    No     | N/A            |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

### References
