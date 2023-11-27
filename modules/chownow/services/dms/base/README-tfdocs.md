<!-- BEGIN_TF_DOCS -->
# Managed Delivery Service on ECS

### General

* Description: Managed Delivery Service on ECS
* Created By: Devops
* Module Dependencies:
  * `core-base`
  * `region-base`
  * `global-base`
* Providers : `aws 5.x`
* Terraform Version: 0.14.x

## Usage

* Terraform:

```hcl
module "dms_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/base?ref=cn-dms-base-v2.1.5"

  env = var.env

  # Enabling PrivateLink for MDS
  enable_privatelink               = 1
  service_provider_aws_account_ids = [tostring(var.aws_account_id)]
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_cname\_primary\_vpc\_svpn\_ttl | (optional) describe your variable | `number` | `300` | no |
| alb\_enable\_egress\_allow\_all | allow egress all on alb | `string` | `"1"` | no |
| alb\_ingress\_tcp\_allowed | list of allowed TCP ports | `list` | ```[ "443" ]``` | no |
| alb\_log\_bucket | ALB log bucket name, alb\_logs\_enabled must be on when assigning a bucket | `string` | `"null"` | no |
| alb\_logs\_enabled | boolean to enable/disable ALB logging | `bool` | `false` | no |
| alb\_name\_prefix | alb security group name prefix | `string` | `"alb-pub"` | no |
| alb\_tg\_deregistration\_delay | the amount of time a target group waits for a container to drain in seconds | `number` | `15` | no |
| alb\_tg\_listener\_protocol | ALB Listener protocol | `string` | `"HTTP"` | no |
| alb\_tg\_target\_type | ALB target group target type | `string` | `"ip"` | no |
| container\_port | ingress TCP port for container | `string` | `"8000"` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| enable\_alb\_public | enables/disables alb creation | `number` | `1` | no |
| enable\_ecr | enable/disable ecr repo creation | `string` | `"1"` | no |
| enable\_privatelink | enables/disables privatelink functionality | `number` | `0` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| service | name of app/service | `string` | `"dms"` | no |
| service\_provider\_aws\_account\_ids | list of AWS Account IDs to allow access to privatelink service provider | `list` | `[]` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| tg\_health\_check\_healthy\_threshold | The number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `3` | no |
| tg\_health\_check\_interval | seconds between heath check | `number` | `10` | no |
| tg\_health\_check\_target | ALB target group health check target | `string` | `"/health"` | no |
| tg\_health\_check\_timeout | seconds when no response means a failed health check | `number` | `5` | no |
| vpc\_name\_prefix | vpc name prefix to use as a location of where to pull data source information and to build resources | `string` | `"nc"` | no |
| vpc\_private\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"private_base"` | no |
| wildcard\_domain\_prefix | allows for the addition of wildcard to the name because some chownow accounts have it | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key\_id | kms key id used in dms-app ECS task definition templating |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
