<!-- BEGIN_TF_DOCS -->
# Hermosa Redis Module

### General

* Description: Hermosa Redis terraform module.
* Created By: Sebastien Plisson
* Module Dependencies:
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-redis](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-redis/badge.svg)

## Usage

* Terraform:

```hcl
module "redis" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/redis?ref=cn-hermosa-redis-v2.0.5"
  env    = "uat"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | override availability zones used for the cache instances | `list` | `[]` | no |
| custom\_cname\_endpoint | custom cname endpoint name for A record creation | `string` | `""` | no |
| custom\_name | customize unique name of the redis cluster. | `string` | `""` | no |
| custom\_vpc\_name | override vpc name. | `string` | `""` | no |
| dns\_zone | override DNS zone to use | `string` | `""` | no |
| ec\_rg\_automatic\_failover\_enabled | enables/disables automatic failover for redis replication group | `bool` | `false` | no |
| ec\_rg\_engine\_version | the version number of the cache engine to be used for the cache clusters in this replication group | `string` | `"5.0.6"` | no |
| ec\_rg\_node\_type | elasticache replication group node type | `string` | `"cache.t2.micro"` | no |
| ec\_rg\_number\_cache\_clusters | number of cache clusters (primary and replicas) the replication group will have | `number` | `1` | no |
| elasticache\_param\_family | elasticache parameter group family | `string` | `"redis5.0"` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| private\_dns\_zone | use private DNS zone | `bool` | `true` | no |
| service | unique service name | `string` | `"hermosa"` | no |
| snapshot\_name | name of snapshot to use to restore data. It will create a new resource if changed. | `string` | `""` | no |
| snapshot\_retention\_limit | number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. 0 means snaphot disabled. | `string` | `"0"` | no |
| snapshot\_window | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"08:30-09:30"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| vpc\_name\_prefix | prefix used to locate the vpc by name | `string` | `"main"` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->