# Backup DB


### General

* Description:  A module which creates resources to support service backups
* Created By: Joe Perez
* Module Dependencies:
* Module Components:
  * `s3 bucket`
  * `secrets`
* Providers : `aws 4.x`
* Terraform Version: 0.14.x

![chownow-ops-tools-backup-db](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-ops-tools-backup-db/badge.svg)


### Usage

* Terraform:


```hcl
module "backup-db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/tools/backup/db?ref=chownow-backup-db-v2.0.1"

  env = var.env
}

```
### Initialization

### Terraform

* Run the PTI base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── ops
            └── tools
                └── backup
                    └── db
                        ├── backup_db.tf
                        ├── env_global.tf -> ../../../../../../env_global.tf
                        └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                  |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :----------------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | dev/qa/prod/stg/uat/data | string |    Yes    | N/A   |
| env_inst      | iteration of environment      | eg 00,01,02,etc          | string |    No     | N/A   |



#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |



### Lessons Learned
If there is more than one EC2 MongoDB cluster per account, they need to share a mongobackup user password. This should never be replaced if it already exists because it will break every other EC2 mongodb backup process.


### References
