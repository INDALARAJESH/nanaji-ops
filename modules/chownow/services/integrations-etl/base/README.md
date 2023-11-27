# ChowNow Integrations ETL Database Migration Service Module

### General

* Description: A module to create the AWS Database Migration Service resources for the Integrations ETL process
* Created By: Sebastien Plisson
* Module Dependencies:
  * `aws-core-base`
  * `cn-integrations-etl-db`
  * a source database
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-integrations-etl-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-integrations-etl-base/badge.svg)

### Usage

#### Pre-Flight
1. You must set up a source RDS instance and `integrations-etl` (`ops-tf-modules>chownow>services>integrations-etl>db`) RDS instance
2. Create the database which will be synced in the target database otherwise AWS DMS endpoints will error
3. For the source database one has to use the master user (postgres).
4. Configure replication source db: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html
  The pglogical plugin has an issue on AWS RDS so the plugin part can be skipped (https://stackoverflow.com/questions/67634311/aws-dms-task-failing-after-some-time-in-cdc-mode)
  and require to set pluginName=test_decoding in Extra Connection Attributes.

  WARNING: do not create replication slots manually (AWS DMS will do it itself, and any non consumed replication slot ends up using disk space until none is left)
#### Terraform

* Terraform:

`ops>terraform>environments`

```
ncp
├── global
└── us-east-1
    └── services
        └── integrations-etl
            └── base
                ├── base.tf
                ├── provider.tf
                └── variables.tf
```

* Integrations ETL Base example:

```hcl
module "integrations_etl_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/orderetl/base?ref=cn-integrations-etl-base-v2.0.0"

  env                           = "ncp"
  source_db_instance_identifier = "source-joetest"
  target_server_name            = "integrations-etl-postgres-ncp.1234567890.us-east-1.rds.amazonaws.com"

}
```

#### Post Terraform

1. Update the source and target DMS endpoints with the new credentials
2. Run the Test Connection utility on the source and destination DMS endpoints to verify connectivity
3. Modify the replication task and initiate the first sync. It usually takes 1 hour per 100GB to sync.
4. Run the following the target database:

```sql
GRANT usage on schema aws_dms to <app_user>;
GRANT insert, delete on aws_dms.awsdms_ddl_audit to <app_user>;
GRANT USAGE, SELECT ON SEQUENCE aws_dms.awsdms_ddl_audit_c_key_seq TO <app_user>;
```
**Note: failing to do so will result in postgres migration failures**

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

* The migration may fail because of data type (like hstore) that are not supported out of the box: either exclude the column if not needed or configure the extension on the target database prior to running the migration
### References

* [Using SSL/TLS to encrypt a connection to a DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)
* [How to require SSL when connecting to MySQL on AWS RDS](https://www.laurencegellert.com/2017/08/how-to-require-ssl-when-connecting-to-mysql-on-aws-rds/)
* [Enable binary logging on RDS read replica](https://blog.pythian.com/enabling-binary-logging-rds-read-replica/)
* [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)
* [Choosing the right AWS DMS replication instance for your migration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html)
* [How to troubleshoot binary logging errors in AWS DMS](https://aws.amazon.com/premiumsupport/knowledge-center/dms-binary-logging-aurora-mysql/)
* [AWS DMS: What You Need To Know](https://bryteflow.com/aws-data-migration-service-or-aws-dms-what-you-need-to-know/)
* [AWS DMS Selection Rules](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.SelectionTransformation.Selections.html)
