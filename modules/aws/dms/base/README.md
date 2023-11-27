# AWS Database Migration Service Module

### General

* Description: A module to creates AWS Database Migration Service resources to provide a 1-way sync from one database to another
* Created By: Joe Perez
* Module Dependencies: `aws-global-base`, `aws-core-base`
  * VPC Subnet IDs for the replication instance
  * AWS DMS IAM roles created by global base module
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-dms-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-dms-base/badge.svg)

### Usage

#### Pre-Flight

1. You must set up a source and target RDS instance
2. Create the database which will be synced in the target database otherwise AWS DMS endpoints will error
3. Create a dms specific mysql username in the source and target database instances with access to the database to be synced
4. Make sure the `binlog_format` database parameter on the source database is set to `ROW` (an AWS DMS requirement)
5. Make sure the backup retention on the source database greater than zero (an AWS DMS requirement)



#### Terraform
* Terraform:

```hcl
# Create temporary password that will be replaced with a real password and stored in 1password
resource "random_string" "secret" {
  length      = 32
  special     = false
  lower       = true
  min_lower   = 5
  upper       = true
  min_upper   = 5
  min_numeric = 5
  min_special = 0
}

module "aws_dms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dms/base?ref=aws-dms-base-v2.0.7"

  custom_vpc_name = var.env
  env             = var.env
  service         = var.service
  table_mappings  = file("${path.module}/table-mapping.json")

  source_database_name = "dbname"
  source_engine_name   = data.aws_db_instance.source.engine
  source_password      = random_string.secret.result
  source_port          = data.aws_db_instance.source.port
  source_server_name   = data.aws_db_instance.source.address
  source_username      = var.source_server_username


  target_database_name = "dbname"
  target_engine_name   = var.target_engine_name
  target_password      = random_string.secret.result
  target_port          = var.target_port
  target_server_name   = var.target_server_name
  target_username      = var.target_username

}

```

#### Post Terraform
1. Update the source and target endpoint credentials in the AWS console
2. Run a test on the endpoints to make sure they can connect to the source and target databases
3. Modify the replication task and initiate the first sync. It usually takes 1 hour per 100GB to sync.
4. On postgres implementations, migrations must limit the schema to `public` and run the following the target database:

```sql
GRANT usage on schema aws_dms to <app_user>;
GRANT insert, delete on aws_dms.awsdms_ddl_audit to <app_user>;
GRANT USAGE, SELECT ON SEQUENCE aws_dms.awsdms_ddl_audit_c_key_seq TO <app_user>;
```
**Note: failing to do so will result in postgres migration failures**


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                      | Description                                            | Options       |  Type   | Required? | Notes |
|:-----------------------------------|:-------------------------------------------------------| :------------ |:-------:|:---------:| :---- |
| custom_repl_task_settings          | rendered json of replication task settings             | rendered json | string  |    No     | N/A   |
| custom_vpc_name                    | allows you to override the built-in vpc name reference | a VPC name    | string  |    No     | N/A   |
| env                                | unique environment/stage name                          |               | string  |    Yes    | N/A   |
| env_inst                           | environment instance number                            | 1...n         | string  |    No     | N/A   |
| repl_inst_extra_security_groups    | list of extra security group IDs to attach             |               |  list   |    No     | N/A   |
| repl_task_log_level                | replication task log level                             |               | string  |    No     | N/A   |
| source_database_name               | the source db to replicate/sync                        |               | string  |    Yes    | N/A   |
| source_engine_name                 | the source db engine name                              |               | string  |    Yes    | N/A   |
| source_password                    | initial source db password for AWS DMS to use          |               | string  |    Yes    | N/A   |
| source_port                        | the source db tcp port                                 |               | string  |    Yes    | N/A   |
| source_server_name                 | the source db address                                  |               | string  |    Yes    | N/A   |
| source_extra_connection_attributes | extra connection attributes                            |               | string  |    Mo     | N/A   |
| source_username                    | initial source db username for AWS DMS to use          |               | string  |    Yes    | N/A   |
| table_mappings                     | rules to apply to the database prior to syncing        |               |  file   |    Yes    | N/A   |
| target_database_name               | the target db to replicate/sync                        |               | string  |    Yes    | N/A   |
| target_engine_name                 | the target db engine name                              |               | string  |    Yes    | N/A   |
| target_password                    | initial target db password for AWS DMS to use          |               | string  |    Yes    | N/A   |
| target_port                        | the target db tcp port                                 |               | string  |    Yes    | N/A   |
| target_server_name                 | the target db address                                  |               | string  |    Yes    | N/A   |
| target_username                    | initial target db username for AWS DMS to use          |               | string  |    Yes    | N/A   |
| lob_max_size                       | max size in kilobytes of large values                  |               | integer |    No     |       |

#### Outputs




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

* The DMS specific IAM roles and policies only need to be created once for all AWS DMS deployments in a given AWS account. Provisioning of these resources have been moved to the Global Base module

### Resources

* [Using SSL/TLS to encrypt a conneciton to a DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)
* [How to require SSL when connecting to MySQL on AWS RDS](https://www.laurencegellert.com/2017/08/how-to-require-ssl-when-connecting-to-mysql-on-aws-rds/)
* [Enable binary logging on RDS read replica](https://blog.pythian.com/enabling-binary-logging-rds-read-replica/)
* [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)
* [Choosing the right AWS DMS replication instance for your migration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html)
* [How to troubleshoot binary logging errors in AWS DMS](https://aws.amazon.com/premiumsupport/knowledge-center/dms-binary-logging-aurora-mysql/)
* [AWS DMS: What You Need To Know](https://bryteflow.com/aws-data-migration-service-or-aws-dms-what-you-need-to-know/)
* [How do I set up detailed debug logging for my AWS DMS task?](https://aws.amazon.com/premiumsupport/knowledge-center/dms-enable-debug-logging/)
