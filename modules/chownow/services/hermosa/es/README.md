# Hermosa ElasticSearch Module

### General

* Description: Hermosa ElasticSearch terraform module.
* Created By: Sebastien Plisson
* Module Dependencies:
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-es](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-es/badge.svg)

### Usage

```hcl
module "es" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/es?ref=cn-hermosa-es-v2.1.0"
  env    = "uat"
}
```

### Initialization

### Terraform

* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    └── db
        └── hermosa
            └──es
                ├── es.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name      | Description                                   | Options             |  Type  | Required? | Notes |
| :----------------- | :-------------------------------------------- | :------------------ | :----: | :-------: | :---- |
| env                | unique environment/stage name                 | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst           | iteration of environment                      | eg 00,01,02,etc     | string |    No     | N/A   |
| service            | service name                                  | hermosa             | string |    No     | N/A   |
| vpc_name_prefix    | prefix used to locate the vpc by name         | default: "main"     | string |    No     | N/A   |
| enable_vpc_options | use vpc options to be reachable from VPC only | default: 0          |  int   |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

- `allow_explicit_index` needs to be set for new environments to allow Hermosa to tell the cluster to trigger an index job when running the initial indexing commands. [Full context here](https://chownow.atlassian.net/browse/CN-24338).

### References
