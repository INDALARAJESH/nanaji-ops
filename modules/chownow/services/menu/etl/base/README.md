# ChowNow Menu ETL Database Migration Service Module

### General

* Description: A module to create the AWS Database Migration Service resources for Menu Services
* Created By: Eric Tew
* Module Dependencies:
  * `aws-core-base`
  * `cn-menu-etl-db`
  * a source database
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-menu-etl-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-menu-etl-base/badge.svg)

### Usage

#### Pre-Flight
1. You must set up a source RDS instance and `menu-etl` (`ops-tf-modules>chownow>services>menu>etl>db`) RDS instance
2. Create the database which will be synced in the target database otherwise AWS DMS endpoints will error
3. Create a dms_source mysql username in the source database writer instance with access to the database to be synced

#### Terraform

* Terraform:

`ops>terraform>environments`

```
prod
├── global
└── us-east-1
    └── services
        └── menu
            └──etl
               └──base
                  ├── base.tf
                  ├── provider.tf
                  └── variables.tf
```

* Menu ETL Base example:

`base.tf`
```hcl
module "menu_etl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/etl/base?ref=cn-menu-etl-base-v2.0.0"

  env = var.env
  source_db_cluster_identifier = "menu-mysql-${var.env}"
  target_server_name           = data.aws_db_instance.target.address
  custom_vpc_name              = "nc-${var.env}"
  service                      = "menu-etl"
  
}
```


#### Post Terraform

1. Create new `dms_source` read-only credentials in the RDS source database and store the credentials in 1Password
2. Update the source and target DMS endpoints with the new credentials (use root for target)
3. Run the Test Connection utility on the source and destination DMS endpoints to verify connectivity
4. Modify the replication task and initiate the first sync. It usually takes 1 hour per 100GB to sync.
### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                                            | Options         | Type   | Required? | Notes |
| :---------------------------- | :----------------------------------------------------  | :-------------- | :----: | :-------: | :---- |
| env                           | unique environment/stage name                          |                 | string |  Yes      | N/A   |
| env_inst                      | environment instance number                            | 1...n           | string |  No       | N/A   |
| database_name                 | the db to replicate/sync                               |                 | string |  No       | N/A   |
| source_db_instance_identifier | source db instance name                                |                 | string |  Yes      | N/A   |
| source_username               | initial source db username for AWS DMS to use          |                 | string |  No       | N/A   |
| table_mappings                | rules to apply to the database prior to syncing        |                 | file   |  No       | N/A   |
| target_engine_name            | the target db engine name                              |                 | string |  No       | N/A   |
| target_port                   | the target db tcp port                                 |                 | string |  No       | N/A   |
| target_server_name            | the target db address                                  |                 | string |  Yes      | N/A   |
| target_username               | initial target db username for AWS DMS to use          |                 | string |  No       | N/A   |

#### Outputs

| Variable Name           | Description                                        | Type    | Notes |
| :---------------------- | :------------------------------------------------- | :-----: | :---- |

### Lessons Learned
* Terraform errors on destroy:
    - sync was still active, had to stop via console
    - ordering for replication instance wouldn't allow it to be deleted
    - endpoints couldn't be deleted because they were associated with a task
    - trouble deleting security group, DMS network interface created but not deleted?

* `binlog_format` must be updated to `ROW` for AWS DMS to work. A change to `binlog_format` in a parameter group requires a database reboot




### References

* [Using SSL/TLS to encrypt a conneciton to a DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)
* [How to require SSL when connecting to MySQL on AWS RDS](https://www.laurencegellert.com/2017/08/how-to-require-ssl-when-connecting-to-mysql-on-aws-rds/)
* [Enable binary logging on RDS read replica](https://blog.pythian.com/enabling-binary-logging-rds-read-replica/)
* [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)
* [Choosing the right AWS DMS replication instance for your migration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html)
* [How to troubleshoot binary logging errors in AWS DMS](https://aws.amazon.com/premiumsupport/knowledge-center/dms-binary-logging-aurora-mysql/)
* [AWS DMS: What You Need To Know](https://bryteflow.com/aws-data-migration-service-or-aws-dms-what-you-need-to-know/)
* [AWS DMS Selection Rules](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.SelectionTransformation.Selections.html)
