# ChowNow DMS ETL Database

### General

* Description: A module to create the target database for the ChowNow DMS ETL process
* Created By: Joe Perez
* Module Dependencies:
  * `aws-global-base`
  * `aws-core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-dms-etl-db](https://github.com/ChowNow/ops-tf-modules/workflows/cn-dms-etl-db/badge.svg)

### Usage

* Terraform:

`ops>terraform>environments>${ENV}`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    └── db
        └── dms-etl
            ├── env_global.tf -> ../../../env_global.tf
            ├── etl_db.tf
            └── provider.tf
```

* DMS ETL Database example (Production):

`etl_db.tf`
```hcl
module "dms_etl_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/etl/db?ref=cn-dms-etl-db-v2.0.1"

  env                 = var.env
  extra_ip_allow_list = ["1.2.3.4/32"] # NCP AWS NAT gateway

}

output "database_endpoint" {
  value = module.dms-etl_db.endpoint
}
```

* DMS ETL Database example (Lower Environment):

`etl_db.tf`
```hcl
module "dms-etl_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/etl/db?ref=cn-dms-etl-db-v2.0.1"

  env             = var.env
  vpc_name_prefix = "nc"
}
```

### RDS MYSQL Configuration

#### Source Database

* Connect to jumpbox in the given environment
```
  aws-vault exec uat -- aws-connect -n jump0-uat
```

* On source database, grant privileges to root user:
```
  psql -U root -h dms-postgres-uat.ciy7tql4pibi.us-east-1.rds.amazonaws.com "dbname=dms"

  dms=> grant all privileges on database dms to root;
```


#### Target Databse

* Add the PostGIS extension:

```
postgres=> \c dms
dms=> CREATE EXTENSION postgis;
CREATE EXTENSION
dms=> \dx
                                     List of installed extensions
  Name   | Version |   Schema   |                             Description
---------+---------+------------+---------------------------------------------------------------------
 plpgsql | 1.0     | pg_catalog | PL/pgSQL procedural language
 postgis | 2.5.2   | public     | PostGIS geometry, geography, and raster spatial types and functions
```
_Note: this is specific to ChowNow DMS and the data that it stores_



* Connect to Pritunl VPN
* Get current password created by terraform
```
  aws-vault exec ops -- terraform state show 'module.dms-etl_db.random_string.secret'
```
* Download ssl cert for [us-east-1](https://truststore.pki.rds.amazonaws.com/us-east-1/us-east-1-bundle.pem) and copy it to your home folder
* Browse to your home folder
* Connect to destination db instance
```
  psql -U root -h dms-etl-postgres-uat.ciy7tql4pibi.us-east-1.rds.amazonaws.com "dbname=postgres sslrootcert=us-east-1-bundle.pem sslmode=verify-full"
```

* Change the database instance's `root` user password and add it to 1Password
```
postgres=> ALTER ROLE root WITH PASSWORD 'NEWPASSWORDGOESHERE';
```
_Note: don't forget to add this password to the proper environment's 1Password vault_

* Create `dms` database from shell
```
postgres=> CREATE DATABASE dms;
```
* Confirm database Creation:

```
postgres=> SELECT datname FROM pg_database;                                                  datname
-----------
 template0
 rdsadmin
 template1
 postgres
 dms
```

* Create a `dms_target` user for the AWS DMS endpoint to use to connect and give it access to the `dms` database. Put the credentials in 1Password:

```
postgres=> create user dms_target with password 'NEWPASSWORDGOESHERE';
postgres=> GRANT ALL PRIVILEGES ON DATABASE dms TO dms_target;
postgres=> ALTER SCHEMA public OWNER TO dms_target;
```
_Note: don't forget to add this password to the proper environment's 1Password vault_

* Create a `fivetran` user for the FiveTran service to connect and give it **READ/REPLICATION** access to the `dms` database. Put the credentials in 1Password:

```
postgres=> create user fivetran with password 'NEWPASSWORDGOESHERE';
postgres=> GRANT USAGE ON SCHEMA public TO fivetran;
postgres=> GRANT CONNECT ON DATABASE dms to fivetran;
postgres=> GRANT SELECT ON ALL TABLES IN SCHEMA public TO fivetran;
```
_Note: don't forget to add this password to the proper environment's 1Password vault_

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                                                          | Options  |  Type  | Required? | Notes |
| :------------------ | :------------------------------------------------------------------- | :------- | :----: | :-------: | :---- |
| custom_vpc_name     | Allows you to override where the `dms-etl` db resources are created  | VPC Name | string |    No     | N/A   |
| extra_ip_allow_list | list of IPs in CIDR notation to allow access to the dms ETL database |          |  list  |    Yes    | N/A   |
| env                 | unique environment/stage name                                        |          | string |    Yes    | N/A   |
| env_inst            | environment instance number                                          | 1...n    | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned



### References

* [ChowNow DMS ETL Infrastructure](https://chownow.atlassian.net/wiki/spaces/CE/pages/2626912279/ChowNow+DMS+ETL+Infrastructure)
* [FiveTran postgres connector](https://fivetran.com/docs/databases/postgresql/setup-guide)
