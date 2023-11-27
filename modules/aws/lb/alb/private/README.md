# Private ALB

### General

* Description: A module to create a private ALB
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-alb-private](https://github.com/ChowNow/ops-tf-modules/workflows/aws-alb-private/badge.svg)

### Usage


* ALB with fixed response:

```hcl
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/private?ref=aws-alb-private-v2.0.1"

  alb_log_bucket             = local.alb_log_bucket
  certificate_arn            = data.aws_acm_certificate.star_chownow.arn
  cname_subdomain_alb        = "admin-origin"
  env                        = var.env
  name_prefix                = "admin"
  service                    = var.service
  vpc_id                     = data.aws_vpc.selected.id

  security_group_ids = [
    data.aws_security_group.internal_env.id,
  ]
}
```

* ALB with forwarding and target group:

```hcl
module "admin_hermosa_alb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/private?ref=aws-alb-private-v2.0.1"

  custom_alb_log_bucket = local.alb_log_bucket
  alb_listener_da_type  = "forward"
  certificate_arn       = data.aws_acm_certificate.star_chownow.arn
  env                   = var.env
  name_prefix           = "admin"
  service               = var.service
  vpc_id                = data.aws_vpc.selected.id

  security_group_ids   = [
    aws_security_group.vpn.id
    ]
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                    | Options                     |  Type  | Required? | Notes |
| :---------------------------- | :----------------------------- | :-------------------------- | :----: | :-------: | :---- |
| custom_alb_log_bucket         | ALB log bucket name            | any bucket name             | string |    No     | N/A   |
| certificate_arn               | ARN for certificate to use     | Certificate ARN             | string |    Yes    | N/A   |
| enable_http_to_https_redirect | creates http to https redirect | 1(true)/0(false)            |  int   |    Yes    | N/A   |
| env                           | unique environment/stage name  | dev/qa/prod/stg/uat         | string |    Yes    | N/A   |
| env_inst                      | iteration of environment       | eg 00,01,02,etc             | string |    No     | N/A   |
| listener_da_type              | listener default action type   | "forward", "fixed-response" | string |    Yes    | N/A   |
| service                       | service name                   | hermosa, flex, etc          | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description          |  Type  | Notes |
| :------------ | :------------------- | :----: | :---- |
| alb_arn       | ALB ARN              | string | N/A   |
| alb_name      | ALB name             | string | N/A   |
| alb_tg_arn    | ALB target group ARN | string | N/A   |
| alb_dns_name  | ALB DNS name         | string | N/A   |
| listener_arn  | ALB listener ARN     | string | N/A   |
| listener_port | ALB listener port    | string | N/A   |




### Lessons Learned

* Tried to make it easy/understandable to get going and provided additional a la carte modules to add listeners, listener rules, and target groups


### References

* [Terraform conditional output issue](https://github.com/hashicorp/terraform/issues/12453)
