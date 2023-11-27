# ChowNow Restaurant Search Database Migration Base Module

### General

* Description: A module to create the AWS Database Migration Service resources for the Restaurant Search Database Migration process
* Created By: Joe Perez
* Module Dependencies:
  * `aws-core-base`
  * `cn-restaurant-search-dm-db`
  * a source database
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-restaurant-search-dm-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-restaurant-search-dm-base/badge.svg)

### Usage

#### Pre-Flight
1. You must set up a source RDS instance and `restaurant-search-dm` (`ops-tf-modules>chownow>services>restaurant-search>dm>db`) RDS instance
2. Create the database which will be synced in the target database otherwise AWS DMS endpoints will error
3. Create a dms specific mysql username in the source and target database instances with access to the database to be synced
4. Make sure the binlog_format database parameter on the source database is set to ROW (an AWS DMS requirement)
5. Make sure the backup retention on the source database greater than zero (an AWS DMS requirement)

#### Terraform

* Terraform:

`ops>terraform>environments`

```
prod
├── global
└── us-east-1
    └── services
        └── restaurant-search
            └── dm
                ├── base
                │   ├── rsdm_db.tf
                │   ├── provider.tf
                │   └── env_global.tf
                └── db
```

* Restaurant Search Database Migration Base example:

`rsdm_base.tf`
```hcl
module "restaurant_search_dm_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/dm/base?ref=cn-restaurant-search-dm-base-v2.0.3"

  env                           = "prod"
  source_db_instance_identifier = "source-joetest"
  target_server_name            = "restaurant-search-dm-mysql-ncp.1234567890.us-east-1.rds.amazonaws.com"

}
```
_Note: the staticly defined `target_server_value` value is required here unless we add multi-credential support to our Jenkins terraform job to pull information from another AWS account._


* Restaurant Search Database Migration Base example(lower environment):

`rsdm_base.tf`
```hcl

module "restaurant_search_dm_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/dm/base?ref=cn-restaurant-search-dm-base-v2.0.6"

  env                           = var.env
  source_db_instance_identifier = "hermosa-mysql-${var.env}"
  database_name                 = "hermosa"
  target_server_name            = data.aws_db_instance.rsdm_db.address

}
```

`data_source.tf`
```hcl
data "aws_db_instance" "rsdm_db" {
  db_instance_identifier = "restaurant-search-dm-mysql-${var.env}"
}
```

#### Post Terraform

1. Create new `dms_source` and `dms_target` credentials in the RDS source and target databases and store the credentials in 1Password
2. Update the source and target DMS endpoints with the new credentials
3. Run the Test Connection utility on the source and destination DMS endpoints to verify connectivity
4. Modify the replication task and initiate the first sync. It usually takes 1 hour per 100GB to sync.


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                                            | Options | Type   | Required? | Notes |
|:------------------------------| :----------------------------------------------------  |:--------| :----: | :-------: | :---- |
| env                           | unique environment/stage name                          |         | string |  Yes      | N/A   |
| env_inst                      | environment instance number                            | 1...n   | string |  No       | N/A   |
| database_name                 | the db to replicate/sync                               |         | string |  No       | N/A   |
| source_db_instance_identifier | source db instance name                                |         | string |  Yes      | N/A   |
| source_username               | initial source db username for AWS DMS to use          |         | string |  No       | N/A   |
| table_mappings                | rules to apply to the database prior to syncing        |         | file   |  No       | N/A   |
| target_engine_name            | the target db engine name                              |         | string |  No       | N/A   |
| target_port                   | the target db tcp port                                 |         | string |  No       | N/A   |
| target_server_name            | the target db address                                  |         | string |  Yes      | N/A   |
| target_username               | initial target db username for AWS DMS to use          |         | string |  No       | N/A   |
| lob_max_size                  | max size in kilobytes of large values                  |         | integer |    No     |       |

#### Outputs

| Variable Name           | Description                                        | Type    | Notes |
| :---------------------- | :------------------------------------------------- | :-----: | :---- |

### Lessons Learned


### References

* [Restaurant Search Database Migration Infrastructure](https://chownow.atlassian.net/wiki/spaces/CE/pages/2616098817/Restaurant+Search+Database+Migration+Infrastructure)
