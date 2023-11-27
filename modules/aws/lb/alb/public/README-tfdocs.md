<!-- BEGIN_TF_DOCS -->
# Public ALB

### General

* Description: A module to create a public ALB
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-alb-public](https://github.com/ChowNow/ops-tf-modules/workflows/aws-alb-public/badge.svg)

## Usage

* Terraform:

```hcl
# ALB with fixed response:
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.8"

  certificate_arn            = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_cloudflare = "admin-cf"
  cname_subdomain_alb        = "admin-origin"
  env                        = var.env
  name_prefix                = "admin"
  service                    = var.service
  vpc_id                     = data.aws_vpc.selected.id

  security_group_ids = [
    data.aws_security_group.vpn_web.id,
    data.aws_security_group.ingress_cloudflare.id,
    data.aws_security_group.internal_env.id,
  ]
}

# ALB with forwarding and target group:
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.7"

  alb_listener_da_type = "forward"
  certificate_arn      = data.aws_acm_certificate.star_chownow.arn
  env                  = var.env
  name_prefix          = "admin"
  service              = var.service
  vpc_id               = data.aws_vpc.selected.id

  enable_gdpr_cname_cloudflare = 1

  security_group_ids   = [
    aws_security_group.vpn.id
    ]
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_logs\_enabled | boolean to enable/disable logging | `bool` | `true` | no |
| alb\_name | custom alb name | `string` | `""` | no |
| certificate\_arn | ARN for certificate to be used by ALB | `any` | n/a | yes |
| cf\_geo\_country | cloudflare geolocation country, star indicates default policy | `string` | `"*"` | no |
| cf\_geo\_identifier | cloudflare geolocation identity | `string` | `"Default"` | no |
| cloudflare\_domain | cloudflare domain to be appended to the end of cname desination | `string` | `"cdn.cloudflare.net"` | no |
| cname\_subdomain\_alb | subdomain name for cname creation | `string` | `""` | no |
| cname\_subdomain\_cloudflare | cloudflare | `string` | `""` | no |
| custom\_alb\_log\_bucket | alb log bucket name | `string` | `""` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| enable\_gdpr\_cname\_cloudflare | enables the creation of a gdpr cname for geolocation routing purposes | `number` | `0` | no |
| enable\_geolocation | enable default geolocation for subdomain record | `number` | `0` | no |
| enable\_http\_to\_https\_redirect | enables http to http redirect | `string` | `"0"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| gdpr\_destination | cname destination for users coming from EU | `string` | `"d19qcrio9y8d0j.cloudfront.net"` | no |
| gdpr\_geo\_continent | GDPR geolocation continent, star indicates default policy | `string` | `"EU"` | no |
| gdpr\_geo\_identifier | GDPR geolocation identity | `string` | `"EU"` | no |
| health\_check\_matcher | ALB target group health check matcher | `string` | `"200"` | no |
| health\_check\_target | The target to check for the load balancer. | `string` | `"/statuscode/200"` | no |
| listener\_da\_fixed\_content\_type | ALB listener default action fixed response content type | `string` | `"text/plain"` | no |
| listener\_da\_fixed\_message\_body | ALB listener default action fixed message body | `string` | `""` | no |
| listener\_da\_fixed\_status\_code | ALB listener default action fixed response status code | `string` | `"421"` | no |
| listener\_da\_type | ALB listener default action type | `string` | `"fixed-response"` | no |
| listener\_port | ALB listener port | `string` | `"443"` | no |
| listener\_protocol | ALB listener protocol | `string` | `"HTTPS"` | no |
| listener\_ssl\_policy | ALB listener ssl policy | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| name\_prefix | name prefix for security group | `string` | `""` | no |
| r53\_ttl\_alb | ALB Route53 record ttl | `string` | `"300"` | no |
| r53\_ttl\_cloudflare | cloudflare cname record ttl | `string` | `"60"` | no |
| r53\_type | ALB Route53 record type | `string` | `"CNAME"` | no |
| security\_group\_ids | list of security ID groups for ALB | `list` | `[]` | no |
| security\_group\_name | custom security group name | `string` | `""` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| tg\_port | custom port for target group | `string` | `""` | no |
| tg\_protocol | protocol for target group | `string` | `"HTTPS"` | no |
| tg\_target\_type | target group type | `string` | `"instance"` | no |
| vpc\_id | VPC ID for resource creation | `any` | n/a | yes |
| vpc\_public\_subnet\_tag\_key | Used to filter down available subnets | `string` | `"public_base"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn | n/a |
| alb\_dns\_name | n/a |
| alb\_name | n/a |
| alb\_sg\_id | ID for the security group created by this module |
| alb\_tg\_arn | ALB target group ARN when the listener default action type is forward |
| listener\_arn | n/a |
| listener\_port | n/a |

### Lessons Learned

* Tried to make it easy/understandable to get going and provided additional a la carte modules to add listeners, listener rules, and target groups

### References

* [Terraform conditional output issue](https://github.com/hashicorp/terraform/issues/12453)

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->