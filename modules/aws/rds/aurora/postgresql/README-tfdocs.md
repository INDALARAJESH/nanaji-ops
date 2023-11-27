<!-- BEGIN_TF_DOCS -->
# Aurora Cluster - postgresql

### General

* Description: A module to create a postgresql Aurora Cluster which includes the db cluster, db instance(s), db subnet group, db monitoring role
* Created By: Joe Perez, Karol Kania
* Module Dependencies:
  * `aws-core-base`
  * `aws-global-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-aurora-postgresql](https://github.com/ChowNow/ops-tf-modules/workflows/aws-aurora-postgresql/badge.svg)

## Usage

* Terraform:

```hcl
/*
 * NOTE: DB ENGINE VERSION AND PARAMETER GROUPS FAMILY MUST HAVE THE MATCHING MAJOR VERSION:
 * -- db_engine_version == 12.10 && family == aurora-postgresql12
 * -- db_engine_version == 13.6 && family == aurora-postgresql13
 */

/*
 * Simple Aurora Cluster/Database:
 */

/*
 * Note: The Cluster and Instance parameter group were intentionally created outside of the module
 * for better visibility and more flexibility.
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-cluster-%s", local.service, local.env),
    )
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-instance-%s", local.service, local.env),
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_engine_version                = "13.6"
  db_database_name                 = "chownow"
}

/*
 * Database Cluster from snapshot:
 */

/*
 * _Note: any username/password/database name parameters set will be overridden by the snapshot_
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-cluster-%s", local.service, local.env),
    )
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-instance-%s", local.service, local.env),
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_engine_version                = "13.6"
  db_database_name                 = "chownow"
  db_snapshot_identifier           = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
}


/*
 * Terraform (extended example):
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql12"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-cluster-%s", local.service, local.env),
    )
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql12"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-instance-%s", local.service, local.env),
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  # DB Cluster Variables
  custom_db_password              = random_password.master_password.result
  db_apply_immediately            = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster.name
  db_database_name                = "chownow"
  db_engine_version               = "12.10"
  db_backup_retention_period      = 7
  db_snapshot_identifier          = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
  db_username                     = var.db_username

  # DB Instance Variables
  count_cluster_instances          = 2
  db_instance_class                = var.db_instance_class
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_performance_insights_enabled  = true

  # DB DNS Variables
  custom_cname_endpoint        = "db-master"  # eg. db-master.uat.aws.chownow.com
  custom_cname_endpoint_reader = "db-replica" # eg. db-replica.uat.aws.chownow.com
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_apply\_immediately | boolean to allow cluster changes to happen immediately | `bool` | `false` | no |
| count\_cluster\_instances | the number of database instances to create in the cluster | `number` | `2` | no |
| custom\_cluster\_identifier | identifier override for resource placement | `string` | `""` | no |
| custom\_cname\_endpoint | custom cname endpoint name for A record creation | `string` | `""` | no |
| custom\_cname\_endpoint\_reader | custom cname endpoint name for A record creation | `string` | `""` | no |
| custom\_db\_password | override database password during creation (does not apply to snapshot restores) | `string` | `""` | no |
| custom\_name | Name override for resource placement | `string` | `""` | no |
| custom\_vpc\_name | vpc override for resource placement | `string` | `""` | no |
| db\_allow\_major\_version\_upgrade | allow major db version upgrade | `bool` | `false` | no |
| db\_apply\_immediately | boolean to allow changes to be applied immediately | `bool` | `false` | no |
| db\_auto\_minor\_version\_upgrade | boolean for allowing automatic minor version upgrades | `bool` | `false` | no |
| db\_backup\_retention\_period | database backup retention period | `number` | `3` | no |
| db\_backup\_window | 30 minute time window to reserve for backups | `string` | `"07:49-08:19"` | no |
| db\_ca\_cert\_identifier | database certificate identifier | `string` | `"rds-ca-2019"` | no |
| db\_cluster\_parameter\_group\_name | parameter group name to use with this cluster | `any` | n/a | yes |
| db\_database\_name | name of database inside cluster | `any` | n/a | yes |
| db\_deletion\_protection | Enable deletion protection on cluster | `bool` | `true` | no |
| db\_enable\_monitoring | enables/disables monitoring role creation | `number` | `1` | no |
| db\_enabled\_cloudwatch\_logs\_exports | list of cloudwatch log exports to enable on cluster | `list` | ```[ "postgresql" ]``` | no |
| db\_engine | database kind | `string` | `"aurora-postgresql"` | no |
| db\_engine\_mode | database engine mode which will be provisioned or serverless | `string` | `"provisioned"` | no |
| db\_engine\_version | database version | `string` | `"13.6"` | no |
| db\_instance\_class | database instance size | `string` | `"db.t3.medium"` | no |
| db\_instance\_parameter\_group\_name | parameter group for the instance | `any` | n/a | yes |
| db\_maintenance\_window | 60 minute time window to reserve for maintenance | `string` | `"mon:05:00-mon:06:00"` | no |
| db\_monitoring\_interval | interval in seconds to monitor database | `number` | `15` | no |
| db\_multi\_az | boolean for turning on/off multi-az | `bool` | `true` | no |
| db\_name\_suffix | name suffix for cname | `string` | `"primary"` | no |
| db\_performance\_insights\_enabled | boolean to enable/disable performance insights on database instance | `bool` | `true` | no |
| db\_iam\_database\_authentication\_enabled | boolean to enable/disable iam database auth on database instance | `bool` | `true` | no |
| db\_publicly\_accessible | boolean for allowing public internet access | `bool` | `false` | no |
| db\_security\_group\_ids | additional vpc security groups for database | `list` | `[]` | no |
| db\_skip\_final\_snapshot | boolean to skip final snapshot for database | `bool` | `true` | no |
| db\_snapshot\_identifier | ARN of snapshot you wish to restore from | `string` | `""` | no |
| db\_storage\_encrypted | type of storage | `bool` | `true` | no |
| db\_storage\_type | type of storage | `string` | `"gp2"` | no |
| db\_tcp\_port | Ingress database TCP port | `string` | `"5432"` | no |
| db\_username | master database username | `string` | `"root"` | no |
| dns\_record\_ttl | TTL for cname record | `string` | `"900"` | no |
| dns\_record\_type | database record type | `string` | `"CNAME"` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| enable\_cname\_creation | enable/disable cname creation | `number` | `1` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| ingress\_source\_security\_group\_id | optional security group id for ingress | `string` | `""` | no |
| password\_length | character length for randomly generated password | `number` | `20` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `string` | `"main"` | no |
| vpc\_subnet\_list | Used to filter down available subnets | `list` | `[]` | no |
| vpc\_subnet\_tag\_value | Used to filter down available subnets | `string` | `"private_base"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | n/a |
| cluster\_identifier | n/a |
| endpoint | the database's address |
| pgmaster\_password | n/a |

## Lessons Learned

* The cluster and instance parameter groups were intentionally created outside of the module for better visibility and more flexibility
* NOTE: DB ENGINE VERSION AND PARAMETER GROUPS FAMILY MUST HAVE THE MATCHING MAJOR VERSION:
  * db_engine_version == 12.10 && family == aurora-postgresql12
  * db_engine_version == 13.6 && family == aurora-postgresql13
* If you restore from a snapshot, there's a chance that terraform will timeout on you and give the error below. AWS will continue to restore the database and it will come up fine.
```
Error: Error waiting for RDS Cluster state to be "available": timeout while waiting for state to become 'available' (last state: 'migrating', timeout: 2h0m0s)
```

RDS Aurora versions availability can slightly differ from the RDS Community.
For instance, at the moment of writing this module the newest available versions for each were the following:

- RDS Community PostgreSQL = 14.2
- RDS Aurora PostgreSQL = 13.6

One can easily verify the availability by invoking the `aws rds describe-db-engine-versions` API call:

`$ aws rds describe-db-engine-versions --engine aurora-postgresql | jq '.DBEngineVersions | .[] | .EngineVersion'`

```
"10.14"
"10.14"
"10.16"
"10.17"
"10.18"
"10.19"
"10.20"
"11.9"
"11.11"
"11.12"
"11.13"
"11.14"
"11.15"
"12.4"
"12.6"
"12.7"
"12.8"
"12.9"
"12.10"
"13.3"
"13.4"
"13.5"
"13.6"
```

## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
