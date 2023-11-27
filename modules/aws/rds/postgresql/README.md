# RDS PostgreSQL Database
![aws-rds-postgres](https://github.com/ChowNow/ops-tf-modules/workflows/aws-rds-postgres/badge.svg)

### General

* Description: A module to create a single node RDS PostgreSQL database
* Created By: Joe Perez
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`

### Usage

* Terraform:

```hcl
// Read pgmaster_password from SecretsManager

module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.1.3"

  db_backup_retention_period = 7
  env                        = "dev"
  pgmaster_secret_name       = "${var.env}/${var.service}/pgmaster_password"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}
```

```hcl
// Create pgmaster_password

module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.1.3"

  db_backup_retention_period = 7
  env                        = "dev"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}
```



### Initialization

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to postgres database: `nc -zv service-master.uat.aws.chownow.com 5432` (change `service` to actual service name)
* Add postgis: `psql -U root -W -h service.address -c "CREATE EXTENSION IF NOT EXISTS postgis;" service` (change `service` to actual service name)
* Create new user: `createuser -h service-master.uat.aws.chownow.com -U root -W -dPE service` (change `service` to the actual service name)
  * Enter service password twice
  * Enter root password to authenticate
* Verify `psql` connectivity: `psql -U service -h service-master.uat.aws.chownow.com -d service` (change `service` to the actual service name)


### Options

* Description: Input variable options and Outputs for other modules to consume
*
#### Inputs

| Variable Name           | Description                   | Options                                 |  Type  | Required? | Notes |
| :---------------------- | :---------------------------- | :-------------------------------------- | :----: | :-------: | :---- |
| env                     | unique environment/stage name |                                         | string |    Yes    | N/A   |
| pgmaster_secret_name    | secretsmanager path           | existing path                           | string |    No     | N/A   |
| service                 | service name                  | hermosa, flex, etc                      | string |    Yes    | N/A   |
| vpc_name_prefix         | VPC name prefix               | nc, etc                                 | string |    Yes    | N/A   |
| rds_logical_replication | enable logical replication    | 0/1                                     |  int   |    No     | N/A   |
| wal_sender_timeout      | set wal_sender_timeout        | use 0 when enabling logical replication |  int   |    No     | N/A   |

#### Outputs

| Variable Name     | Description        |  Type  | Notes     |
| :---------------- | :----------------- | :----: | :-------- |
| address           | database's address | string |           |
| db_id             | database ID        | string |           |
| pgmaster_password | database pw        | string | sensitive |


### Lessons Learned


### References

* https://stackoverflow.com/questions/46041396/multiple-availability-zones-with-terraform-on-aws
