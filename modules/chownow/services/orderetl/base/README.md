# ChowNow Order ETL Database Migration Service Module

### General

* Description: A module to create the AWS Database Migration Service resources for the Order ETL process
* Created By: Joe Perez
* Module Dependencies:
  * `aws-core-base`
  * `cn-orderetl-db`
  * a source database
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-orderetl-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-orderetl-base/badge.svg)

### Usage

#### Pre-Flight
1. You must set up a source RDS instance and `orderetl` (`ops-tf-modules>chownow>services>orderetl>db`) RDS instance
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
        └── orderetl
            └── base
                ├── base.tf
                ├── provider.tf
                └── variables.tf
```

* Order ETL Base example:

`base.tf`
```hcl
module "orderetl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/orderetl/base?ref=cn-orderetl-base-v2.0.7"

  env                           = "prod"
  source_db_instance_identifier = "source-joetest"
  target_server_name            = "orderetl-mysql-ncp.1234567890.us-east-1.rds.amazonaws.com"

}
```

* Order ETL Base example(lower environment):

`base.tf`
```hcl

module "orderetl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/orderetl/base?ref=cn-orderetl-base-v2.0.7"

  env                           = var.env
  source_db_instance_identifier = "hermosa-mysql-${var.env}"
  database_name                 = "hermosa"
  target_server_name            = "orderetl-mysql-qa.1234567890.us-east-1.rds.amazonaws.com"

}
```


#### Post Terraform

1. Create new `orderetl` credentials in the RDS source and target databases and store the credentials in 1Password
2. Update the source and target DMS endpoints with the new credentials
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


* You need to enable `log_bin` mysql parameter/variable by having backup retention set greater than zero

> When creating a Read Replica, there are a few things to consider. First, you must enable automatic backups on the source DB instance by setting the backup retention period to a value other than 0. This requirement also applies to a Read Replica that is the source DB instance for another Read Replica. For MySQL DB instances, automatic backups are supported only for Read Replicas running MySQL 5.6 and later, but not for MySQL versions 5.5. To enable automatic backups on an Amazon RDS MySQL version 5.6 and later Read Replica, first create the Read Replica, then modify the Read Replica to enable automatic backups.

* Connecting to RDS mysql 5.7 with SSL: `mysql -h target.12345678.us-east-1.rds.amazonaws.com -u user -p --ssl-ca=/path/to/rds-combined-ca-bundle.pem --ssl-mode=VERIFY_CA`

### References

* [Using SSL/TLS to encrypt a conneciton to a DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)
* [How to require SSL when connecting to MySQL on AWS RDS](https://www.laurencegellert.com/2017/08/how-to-require-ssl-when-connecting-to-mysql-on-aws-rds/)
* [Enable binary logging on RDS read replica](https://blog.pythian.com/enabling-binary-logging-rds-read-replica/)
* [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)
* [Choosing the right AWS DMS replication instance for your migration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html)
* [How to troubleshoot binary logging errors in AWS DMS](https://aws.amazon.com/premiumsupport/knowledge-center/dms-binary-logging-aurora-mysql/)
* [AWS DMS: What You Need To Know](https://bryteflow.com/aws-data-migration-service-or-aws-dms-what-you-need-to-know/)
* [AWS DMS Selection Rules](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.SelectionTransformation.Selections.html)
