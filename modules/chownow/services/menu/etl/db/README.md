# ChowNow Menu ETL Database

### General

* Description: A module to create the target database for the ETL process
* Created By: Eric Tew
* Module Dependencies:
  * `aws-core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-menu-etl-db](https://github.com/ChowNow/ops-tf-modules/workflows/cn-menu-etl-db/badge.svg)

### Usage

* Terraform:

`ops>terraform>environments`
```
env
├── global
└── us-east-1
    └── db
        └── menu
            └──etl
               ├── etl_db.tf
               ├── provider.tf
               └── variables.tf
```

* Menu ETL Database example:

`etl_db.tf`
```hcl
module "menu_etl_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/etl/db?ref=cn-menu-etl-db-v2.0.0"

  env             = var.env
  vpc_name_prefix = "nc"

}
```


### RDS MYSQL Configuration

* Change the database instance's `root` user password and add it to 1Password
* Create `menu` database

```
mysql> create database menu;
Query OK, 1 row affected (0.09 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| menu               |
| innodb             |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

* Create a `fivetran` user for the FiveTran service to connect and give it **READ/REPLICATION** access to the `menu` database. Put the credentials in 1Password:

```
mysql> CREATE USER 'fivetran'@'%' IDENTIFIED BY '32CHARACTERCOMPLEXPASSWORDGOESHERE';
Query OK, 0 rows affected (0.09 sec)

mysql> GRANT SELECT ON menu.* TO 'fivetran'@'%';
Query OK, 0 rows affected (0.09 sec)

mysql> ALTER USER 'fivetran'@'%' REQUIRE SSL;
Query OK, 0 rows affected (0.09 sec)

mysql> use menu;
Database changed

mysql> GRANT REPLICATION CLIENT ON *.* TO fivetran;
Query OK, 0 rows affected (0.09 sec)

mysql> GRANT REPLICATION SLAVE ON *.* TO fivetran;
Query OK, 0 rows affected (0.09 sec)

mysql> CALL mysql.rds_set_configuration('binlog retention hours', 48);
Query OK, 0 rows affected (0.09 sec)

mysql> CALL mysql.rds_show_configuration;
+------------------------+-------+-----------------------------------------------------------------------------------------------------------+
| name                   | value | description                                                                                               |
+------------------------+-------+-----------------------------------------------------------------------------------------------------------+
| binlog retention hours | 48    | binlog retention hours specifies the duration in hours before binary logs are automatically deleted.      |
| source delay           | 0     | source delay specifies replication delay in seconds between current instance and its master.              |
| target delay           | 0     | target delay specifies replication delay in seconds between current instance and its future read-replica. |
+------------------------+-------+-----------------------------------------------------------------------------------------------------------+
3 rows in set (0.08 sec)

Query OK, 0 rows affected (0.08 sec)

```
_Note: binlog retention hours being set is a fivetran requirement_


### Source Database (menu/db)

* Create a `dms_source` user for the AWS DMS endpoint to use to connect and give it access to the `menu` database. Put the credentials in 1Password:

```
mysql> CREATE USER 'dms_source'@'%' IDENTIFIED BY '32CHARACTERCOMPLEXPASSWORDGOESHERE';
Query OK, 0 rows affected (0.09 sec)

mysql> GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'dms_source'@'%';
Query OK, 0 rows affected (0.09 sec)
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                                                            | Options         |  Type  | Required? | Notes |
| :------------------- | :--------------------------------------------------------------------- | :-------------- | :----: | :-------: | :---- |
| custom_vpc_name      | Allows you to override where the db resources are created              | VPC Name        | string |    No     | N/A   |
| db_allocated_storage | disk space for database in GB                                          | (default: 2000) |  int   |    No     | N/A   |
| extra_ip_allow_list  | list of IPs in CIDR notation to allow access to the Menu ETL database  |                 |  list  |    Yes    | N/A   |
| env                  | unique environment/stage name                                          |                 | string |    Yes    | N/A   |
| env_inst             | environment instance number                                            | 1...n           | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### References
* [SSL on RDS mysql](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.SSLSupport)
* [FiveTran mysql connector](https://fivetran.com/docs/databases/mysql/setup-guide)
