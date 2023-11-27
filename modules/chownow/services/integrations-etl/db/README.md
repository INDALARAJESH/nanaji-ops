# ChowNow Integrations ETL Database

### General

* Description: A module to create the target database for the ETL process
* Created By: Sebastien Plisson
* Module Dependencies:
  * `aws-core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![cn-integrations-etl-db](https://github.com/ChowNow/ops-tf-modules/workflows/cn-integrations-etl-db/badge.svg)

### Usage

* Terraform:

`ops>terraform>environments`
```
env
├── global
└── us-east-1
    └── db
        └── integrations-etl
            ├── integrations-etl_db.tf
            ├── provider.tf
            └── variables.tf
```

* Integrations ETL Database example:

`integrations-etl_db.tf`
```hcl
module "integrations-etl_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/integrations-etl/db?ref=cn-integrations-etl-db-v2.0.1"

  env                 = var.env
  extra_ip_allow_list = ["1.2.3.4/32"] #prod aws NAT gateway

}
```

### RDS MYSQL Configuration

* Connect to jumpbox
```
  aws-vault exec uat -- aws-connect -n jump0-uat
```

* On source database, grant privileges to root user:
```
  psql -U root -h integrations-postgres-uat.ciy7tql4pibi.us-east-1.rds.amazonaws.com "dbname=integrations"
  
  integrations=> grant all privileges on database integrations to root;
```  

* Get current password created by terraform
```
  aws-vault exec ops -- terraform state show 'module.integrations-etl_db.random_string.secret'
```
* Download ssl cert pem file: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html
* Connect to destination db instance
```
  psql -U root -h integrations-etl-postgres-uat.ciy7tql4pibi.us-east-1.rds.amazonaws.com "dbname=postgres sslrootcert=us-east-1-bundle.pem sslmode=verify-full"
```

* Change the database instance's `root` user password and add it to 1Password
```
postgres=> ALTER ROLE root WITH PASSWORD 'new password';
```
* Create `integrations` database from shell
```
  createdb -U root -h integrations-etl-postgres.uat.svpn.chownow.com integrations
```

* Create a `dms_target` user for the AWS DMS endpoint to use to connect and give it access to the `chownow` database. Put the credentials in 1Password:

```
  psql -U root -h integrations-etl-postgres.uat.svpn.chownow.com -d integrations
integrations=> create user dms_target with password 'PASSWORD';
integrations=> GRANT ALL PRIVILEGES ON DATABASE integrations TO dms_target;
integrations=> ALTER SCHEMA public OWNER TO dms_target;
```

* Create a `fivetran` user for the FiveTran service to connect and give it **READ/REPLICATION** access to the `chownow` database. Put the credentials in 1Password:

```
integrations=> create user fivetran with password 'PASSWORD';
integrations=> GRANT USAGE ON SCHEMA public TO fivetran;
integrations=> GRANT CONNECT ON DATABASE integrations to fivetran;
integrations=> GRANT SELECT ON ALL TABLES IN SCHEMA public TO fivetran;
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                                                                   | Options  |  Type  | Required? | Notes |
| :------------------ | :---------------------------------------------------------------------------- | :------- | :----: | :-------: | :---- |
| custom_vpc_name     | Allows you to override where the `integrations-etl` db resources are created  | VPC Name | string |    No     | N/A   |
| extra_ip_allow_list | list of IPs in CIDR notation to allow access to the Integrations ETL database |          |  list  |    Yes    | N/A   |
| env                 | unique environment/stage name                                                 |          | string |    Yes    | N/A   |
| env_inst            | environment instance number                                                   | 1...n    | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

* Connecting to RDS mysql via SSL:
  * Download the (rds-combined-ca-bundle.pem)(https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem) file
  * Download the mysql client
  * Run: `mysql -h integrations-etl-mysql-data.1234567890.us-east-1.rds.amazonaws.com --ssl-ca /path/to/rds-combined-ca-bundle.pem -u USERNAME -p` (changing the hostname to the RDS instance you want to connect to)

### References
* [FiveTran mysql connector](https://fivetran.com/docs/databases/mysql/setup-guide)
