# RDS PostgreSQL Database

### General

* Description: A module to create a single node RDS PostgreSQL database
* Created By: Joe Perez
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`

![aws-rds-postgres](https://github.com/ChowNow/ops-tf-modules/workflows/aws-rds-postgres/badge.svg)


### Initialization

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to postgres database: `nc -zv service-master.uat.aws.chownow.com 5432` (change `service` to actual service name)
* Add postgis: `psql -U root -W -h service.address -c "CREATE EXTENSION IF NOT EXISTS postgis;" service` (change `service` to actual service name)
* Create new user: `createuser -h service-master.uat.aws.chownow.com -U root -W -dPE service` (change `service` to the actual service name)
  * Enter service password twice
  * Enter root password to authenticate
* Verify `psql` connectivity: `psql -U service -h service-master.uat.aws.chownow.com -d service` (change `service` to the actual service name)

