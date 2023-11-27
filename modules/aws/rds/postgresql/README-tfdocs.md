<!-- BEGIN_TF_DOCS -->
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


## Usage

* Terraform:

```hcl
// Read pgmaster_password from SecretsManager
module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.0.1"

  db_backup_retention_period = 7
  env                        = "dev"
  pgmaster_secret_name       = "${var.env}/${var.service}/pgmaster_password"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}

// Create pgmaster_password
module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.0.1"

  db_backup_retention_period = 7
  env                        = "dev"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autovacuum\_naptime | n/a | `string` | `"300"` | no |
| autovacuum\_vacuum\_threshold | n/a | `string` | `"5000"` | no |
| custom\_vpc\_name | vpc override for resource placement | `string` | `""` | no |
| db\_allocated\_storage | size of db disk in gb | `number` | `10` | no |
| db\_apply\_immediately | apply changes immediately, which can cause a reboot, so be careful when enabling | `bool` | `false` | no |
| db\_auto\_minor\_version\_upgrade | boolean for allowing automatic minor version upgrades | `bool` | `false` | no |
| db\_backup\_retention\_period | database backup retention period | `number` | `1` | no |
| db\_backup\_window | 30 minute time window to reserve for backups | `string` | `"07:00-07:30"` | no |
| db\_ca\_cert\_identifier | database certificate identifier | `string` | `"rds-ca-rsa2048-g1"` | no |
| db\_engine | database kind | `string` | `"postgres"` | no |
| db\_engine\_version | database version | `string` | `"11.11"` | no |
| db\_instance\_class | database instance size | `string` | `"db.t3.small"` | no |
| db\_maintenance\_window | 60 minute time window to reserve for maintenance | `string` | `"sun:07:30-sun:08:30"` | no |
| db\_multi\_az | boolean for turning on/off multi-az | `bool` | `true` | no |
| db\_name\_suffix | name suffix for cname | `string` | `"master"` | no |
| db\_performance\_insights\_enabled | boolean to enable/disable performance insights on RDS database | `bool` | `false` | no |
| db\_performance\_insights\_kms\_key\_id | optionally specify KMS key to use for performance insights | `string` | `""` | no |
| db\_performance\_insights\_retention\_period | number of days (min 7) to keep performance insights data | `number` | `0` | no |
| db\_publicly\_accessible | boolean for allowing public internet access | `bool` | `false` | no |
| db\_skip\_final\_snapshot | boolean to skip final snapshot for database | `bool` | `true` | no |
| db\_storage\_encrypted | type of storage | `bool` | `true` | no |
| db\_storage\_type | type of storage | `string` | `"gp2"` | no |
| db\_tcp\_port | Ingress database TCP port | `string` | `"5432"` | no |
| db\_username | master database username | `string` | `"root"` | no |
| db\_vpc\_security\_group\_ids | aws security groups for database | `list` | `[]` | no |
| dns\_record\_ttl | TTL for cname record | `string` | `"900"` | no |
| dns\_record\_type | database record type | `string` | `"CNAME"` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_cidr\_blocks | extra cidr for ingress | `list` | `[]` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| ingress\_source\_security\_group\_id | optional security group id for ingress | `string` | `""` | no |
| is\_private | Toggle private or public zone | `bool` | `true` | no |
| log\_autovacuum\_min\_duration | n/a | `string` | `"1"` | no |
| log\_min\_duration\_statement | n/a | `string` | `"3000"` | no |
| log\_statement | n/a | `string` | `"ddl"` | no |
| max\_connections | n/a | `string` | `"256"` | no |
| pg\_stat\_statements\_track | n/a | `string` | `"ALL"` | no |
| pgmaster\_secret\_name | Secrets Manager secret path | `string` | `""` | no |
| rds\_logical\_replication | n/a | `string` | `"0"` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| shared\_preload\_libraries | n/a | `string` | `"pg_stat_statements"` | no |
| standard\_conforming\_strings | n/a | `string` | `"1"` | no |
| subnet\_tag | Toggle public or private subnet | `string` | `"private"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| track\_activity\_query\_size | n/a | `string` | `"2048"` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `any` | n/a | yes |
| wal\_sender\_timeout | n/a | `string` | `"30000"` | no |
| work\_mem | n/a | `string` | `"64000"` | no |

## Outputs

| Name | Description |
|------|-------------|
| address | the database's address |
| db\_id | n/a |
| db\_identifier | n/a |
| pgmaster\_password | n/a |

## Lessons Learned

## References

* https://stackoverflow.com/questions/46041396/multiple-availability-zones-with-terraform-on-aws

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
