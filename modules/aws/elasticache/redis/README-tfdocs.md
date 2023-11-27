<!-- BEGIN_TF_DOCS -->
# ElastiCache / Redis

### General

* Description: A module to create an ElastiCache/Redis instance
* Created By: Joe Perez
* Module Dependencies:
  * `core-base`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-elasticache-redis](https://github.com/ChowNow/ops-tf-modules/workflows/aws-elasticache-redis/badge.svg)

## Usage

* Terraform:

```hcl
# Terraform (Standalone Redis):
module "redis_standalone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.9"

  env             = "sb"
  service         = "dms"
  vpc_name_prefix = "nc"
}

# Terraform (Redis with read-replica):
# of read-replicas = ec_rg_number_cache_clusters - 1)
module "redis_with_replica" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticache/redis?ref=aws-elasticache-redis-v2.0.9"


  env             = "sb"
  service         = "dms"
  vpc_name_prefix = "nc"

  ec_rg_number_cache_clusters      = 2
  ec_rg_automatic_failover_enabled = true
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_security\_groups | additional security groups to attach to the cluster | `list` | `[]` | no |
| authtoken\_secret\_name | Secrets Manager secret path to the Redis Auth Token | `string` | `""` | no |
| availability\_zones | override availability zones used for the cache instances | `list` | `[]` | no |
| custom\_cname\_endpoint | custom cname endpoint name for A record creation | `string` | `""` | no |
| custom\_name | customize unique name of the redis cluster. Defaults to <service>-redis-<env><env\_inst> | `string` | `""` | no |
| custom\_parameter\_group\_name | custom parameter group to use with elasticache cluster | `string` | `""` | no |
| custom\_vpc\_name | vpc override for resource placement | `string` | `""` | no |
| db\_name\_suffix | name suffix for cname | `string` | `"redis"` | no |
| dns\_record\_ttl | TTL for cname record | `string` | `"900"` | no |
| dns\_record\_type | database record type | `string` | `"CNAME"` | no |
| dns\_zone | use specific dns zone | `string` | `""` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| ec\_at\_rest\_encryption\_enabled | enables/disables encrpytion at rest | `bool` | `true` | no |
| ec\_rg\_automatic\_failover\_enabled | enables/disables automatic failover for redis replication group | `bool` | `false` | no |
| ec\_rg\_engine\_version | the version number of the cache engine to be used for the cache clusters in this replication group | `string` | `"5.0.6"` | no |
| ec\_rg\_node\_type | elasticache replication group node type | `string` | `"cache.t2.micro"` | no |
| ec\_rg\_number\_cache\_clusters | number of cache clusters (primary and replicas) the replication group will have | `number` | `1` | no |
| elasticache\_param\_family | elasticache parameter group family | `string` | `"redis5.0"` | no |
| enable\_parameter\_group | enable parameter group creation in module | `number` | `1` | no |
| enable\_record\_redis\_reader | enable/disable creation of redis reader cname | `number` | `1` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| multi\_az\_enabled | boolean to enable/disable multi-az | `bool` | `true` | no |
| num\_node\_groups | number of node groups in cluster | `number` | `2` | no |
| private\_dns\_zone | allow to fetch private or public dns zone | `bool` | `true` | no |
| redis\_tcp\_port | Ingress redis TCP port | `string` | `"6379"` | no |
| replicas\_per\_node\_group | replicas per node group | `number` | `1` | no |
| secret\_name | name of secret | `string` | `"redis_auth_token"` | no |
| secret\_recovery\_window | allows for secret recovery when deleted, but causes issues when rebuilding infra | `number` | `0` | no |
| service | unique service name for project/application | `string` | `""` | no |
| snapshot\_name | name of snapshot to use to restore data. It will create a new resource if changed. | `string` | `""` | no |
| snapshot\_retention\_limit | number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. 0 means snaphot disabled. | `string` | `"0"` | no |
| snapshot\_window | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"08:30-09:30"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| transit\_encryption\_enabled | boolean to enable transit encryption | `bool` | `true` | no |
| vpc\_name\_prefix | VPC name which is used to determine where to create resources | `string` | `"main"` | no |
| vpc\_private\_subnet\_tag\_value | Used to filter down available subnets | `string` | `"private_base"` | no |

## Outputs

| Name | Description |
|------|-------------|
| auth\_token | n/a |

### Initialization

#### Unencrypted Connection

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to redis: `nc -zv service-redis.uat.aws.chownow.com 6379` (change `service` to actual service name)
* Connect to redis via `redis-cli`: `redis-cli -h service-redis.uat.aws.chownow.com` (change `service` to actual service name)
* Once connected, run `info` to get information about the instance

#### Encrypted Connection

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to redis: `nc -zv service-redis.uat.aws.chownow.com 6379` (change `service` to actual service name)
* Install redli
* with redli:
  * uri way:  `redli --tls -u rediss://admin:PASSWORDGOESHERE@master.service-redis-uat.gt24gi.use1.cache.amazonaws.com -p 6379`
  * host way: `redli --tls -h master.service-redis-uat.gt24gi.use1.cache.amazonaws.com -p 6379 -a PASSWORDGOESHERE`
* Once connected, run `info` to get information about the instance

### Lessons Learned

* If you switch from a parameter created inside the module to one outside, you might run into resource deletion issues. You should change the cluster's parameter group in the console to allow the old parameter group to be deleted.

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
