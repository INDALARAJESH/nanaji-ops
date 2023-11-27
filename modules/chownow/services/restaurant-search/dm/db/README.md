# ChowNow Restaurant Search Database Migration DB Module

### General

* Description: A module to create the target database for the Restaurant Search Database Migration process
* Created By: Joe Perez
* Module Dependencies:
  * `aws-core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-restaurant-search-dm-db](https://github.com/ChowNow/ops-tf-modules/workflows/cn-restaurant-search-dm-db/badge.svg)

### Usage

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
                └── db
                    ├── rsdm_db.tf
                    ├── provider.tf
                    └── env_global.tf
```

* Restaurant Search Database Migration DB example (Production):

`rsdm_db.tf`
```hcl
module "rsdm_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/dm/db?ref=cn-restaurant-search-dm-db-v2.0.1"

  env                 = var.env
  extra_ip_allow_list = ["1.2.3.4/32"] #prod aws NAT gateway

}

output "endpoint" {
  value = module.rsdm_db.endpoint
}
```

* Restaurant Search Database Migration DB example (Lower Environment):

`rsdm_db.tf`
```hcl
module "rsdm_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/dm/db?ref=cn-restaurant-search-dm-db-v2.0.0"

  db_instance_class      = "db.r5.large"
  db_monitoring_interval = 0
  env                    = var.env
  extra_ip_allow_list = ["${data.aws_nat_gateway.main_vpc.public_ip}/32"]
  vpc_name_prefix        = "nc"

}

output "endpoint" {
  value = module.rsdm_db.endpoint
}
```

`data_source.tf`

```hcl
data "aws_nat_gateway" "main_vpc" {

  tags = {
    Name = "main-nat-gw-${var.env}"
  }
}
```



### RDS MYSQL Configuration

* Change the database instance's `root` user password and add it to 1Password
* Create database
  * It's `chownow` in `qa00`/`prod` and `hermosa` in all the other environments

```
mysql> create database chownow;
Query OK, 1 row affected (0.09 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| chownow            |
| innodb             |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

* Create a `dms_target` user for the AWS DMS endpoint to use to connect and give it access to the `chownow` database. Put the credentials in 1Password:

```
mysql> CREATE USER 'dms_target'@'%' IDENTIFIED BY '32CHARACTERCOMPLEXPASSWORDGOESHERE';
Query OK, 0 rows affected (0.09 sec)

mysql> GRANT ALL PRIVILEGES ON chownow.* TO 'dms_target'@'%';
Query OK, 0 rows affected (0.09 sec)
mysql> ALTER USER 'dms_target'@'%' REQUIRE SSL;
Query OK, 0 rows affected (0.18 sec)
```


### Source Database (hermosa/chownow)

**IF IT WASN'T ALREADY CREATED FOR ORDERETL**

* Create a `dms_source` user for the AWS DMS endpoint to use to connect and give it access to the `chownow`/`hermosa` database. Put the credentials in 1Password under each environment's vault
* Connect to the source `hermosa` database:

```
mysql> CREATE USER 'dms_source'@'%' IDENTIFIED BY '32CHARACTERCOMPLEXPASSWORDGOESHERE';
Query OK, 0 rows affected (0.09 sec)

mysql> GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'dms_source'@'%';
Query OK, 0 rows affected (0.09 sec)
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                                                                                 | Options         |  Type  | Required? | Notes |
| :------------------- | :------------------------------------------------------------------------------------------ | :-------------- | :----: | :-------: | :---- |
| custom_vpc_name      | Allows you to override where the db resources are created                                   | VPC Name        | string |    No     | N/A   |
| db_allocated_storage | disk space for database in GB                                                               | (default: 2000) |  int   |    No     | N/A   |
| extra_ip_allow_list  | list of IPs in CIDR notation to allow access to the Restaurant Search Database Migration DB |                 |  list  |    Yes    | N/A   |
| env                  | unique environment/stage name                                                               |                 | string |    Yes    | N/A   |
| env_inst             | environment instance number                                                                 | 1...n           | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

* Connecting to RDS mysql via SSL:
  * Download the (rds-combined-ca-bundle.pem)(https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem) file
  * Download the mysql client
  * Run: `mysql -h restaurant-search-dm-mysql-dev.1234567890.us-east-1.rds.amazonaws.com --ssl-ca /path/to/rds-combined-ca-bundle.pem -u USERNAME -p` (changing the hostname to the RDS instance you want to connect to)

### References

* [Restaurant Search Database Migration Infrastructure](https://chownow.atlassian.net/wiki/spaces/CE/pages/2616098817/Restaurant+Search+Database+Migration+Infrastructure)
* [SSL on RDS mysql](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.SSLSupport)
