<!-- BEGIN_TF_DOCS -->
# RDS Proxy

![aws-rds-proxy](https://github.com/ChowNow/ops-tf-modules/workflows/aws-rds-proxy/badge.svg)

### General

* Description: A module to create an RDS Proxy
* Created By: Karol Kania
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`

## Usage

* Terraform:

```hcl
module "rds_proxy" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/proxy?ref=rds-proxy-v2.0.0"

  env             = local.env
  service         = local.service
  vpc_name_prefix = var.vpc_name_prefix

  secrets = {
    "root" = {
      arn = module.rds_proxy_credentials_insert.secret_arn
    }
  }

  # Target PostgreSQL Instance
  db_engine_family       = "POSTGRESQL"
  target_db_instance     = true
  db_instance_identifier = module.rds_postgres.db_id

  # Optional ingress security ids
  ingress_source_security_group_id = data.aws_security_group.bastion.id
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_ro\_rw\_endpoints | Whether to create additional READ\_ONLY and READ\_WRITE endpoints for this setup | `bool` | `false` | no |
| auth\_scheme | The type of authentication that the proxy uses for connections from the proxy to the underlying database. One of `SECRETS` | `string` | `"SECRETS"` | no |
| connection\_borrow\_timeout | The number of seconds for a proxy to wait for a connection to become available in the connection pool | `number` | `null` | no |
| db\_cluster\_identifier | DB cluster identifier | `string` | `""` | no |
| db\_debug\_logging | Whether the proxy includes detailed information about SQL statements in its logs. | `bool` | `false` | no |
| db\_engine\_family | Valid values are MYSQL and POSTGRESQL. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora | `string` | n/a | yes |
| db\_idle\_client\_timeout | The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it. | `number` | `300` | no |
| db\_instance\_identifier | DB instance identifier | `string` | `""` | no |
| db\_require\_tls | Whether Transport Layer Security (TLS) encryption is required for connections to the proxy | `bool` | `true` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_cidr\_blocks | extra cidr for ingress | `list` | `[]` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| iam\_auth | Whether to require or disallow AWS Identity and Access Management (IAM) authentication for connections to the proxy. One of `DISABLED`, `REQUIRED` | `string` | `"DISABLED"` | no |
| ingress\_source\_security\_group\_id | optional security group id for ingress | `string` | `""` | no |
| init\_query | One or more SQL statements for the proxy to run when opening each new database connection. Initialization query is not currently supported for PostgreSQL. | `string` | `""` | no |
| is\_private | Toggle private or public zone | `bool` | `true` | no |
| max\_connections\_percent | The maximum size of the connection pool for each target in a target group | `number` | `90` | no |
| max\_idle\_connections\_percent | Controls how actively the proxy closes idle database connections in the connection pool | `number` | `50` | no |
| secrets | Map of secrets to be used by RDS Proxy for authentication to the database | ```map(object({ arn = string }))``` | n/a | yes |
| service | unique service name for project/application | `any` | n/a | yes |
| session\_pinning\_filters | Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection | `list(string)` | `[]` | no |
| subnet\_tag | Toggle public or private subnet | `string` | `"private"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| target\_db\_cluster | Determines whether DB cluster is targeted by proxy | `bool` | `false` | no |
| target\_db\_instance | Determines whether DB instance is targeted by proxy | `bool` | `false` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `any` | n/a | yes |
| vpc\_subnet\_ids | One or more VPC subnet IDs to associate with the new proxy. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| proxy\_arn | The Amazon Resource Name (ARN) for the proxy |
| proxy\_default\_target\_group\_arn | The Amazon Resource Name (ARN) for the default target group |
| proxy\_default\_target\_group\_id | The ID for the default target group |
| proxy\_default\_target\_group\_name | The name of the default target group |
| proxy\_endpoint\_default | The endpoint that you can use to connect to the proxy |
| proxy\_endpoint\_ro | The (RO) endpoint that you can use to connect to the proxy (optional) |
| proxy\_endpoint\_rw | The (RW) endpoint that you can use to connect to the proxy (optional) |
| proxy\_id | The ID for the proxy |
| proxy\_target\_endpoint | Hostname for the target RDS DB Instance. Only returned for `RDS_INSTANCE` type |
| proxy\_target\_id | Identifier of `db_proxy_name`, `target_group_name`, target type (e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`), and resource identifier separated by forward slashes (/) |
| proxy\_target\_port | Port for the target RDS DB Instance or Aurora DB Cluster |
| proxy\_target\_rds\_resource\_id | Identifier representing the DB Instance or DB Cluster target |
| proxy\_target\_target\_arn | Amazon Resource Name (ARN) for the DB instance or DB cluster. Currently not returned by the RDS API |
| proxy\_target\_tracked\_cluster\_id | DB Cluster identifier for the DB Instance target. Not returned unless manually importing an RDS\_INSTANCE target that is part of a DB Cluster |
| proxy\_target\_type | Type of target. e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER` |

## Lessons Learned

## References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->