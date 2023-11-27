# Hermosa Base Module

### General

* Description: Hermosa base terraform module. This module creates the admin/web ALBs and other resources which are required before creating the hermosa application and database
* Created By: Joe Perez
* Module Dependencies: `alb-public`, `alb-listener`, `alb-listener-rule` `alb-target-group`, `cloudflare-sg`
* Module Components:
  * `admin alb`
  * `admin target group(s)`
  * `admin listener rules`
  * `web alb`
  * `web target group`
  * `web listener rules`
  * `web route53 cnames`
  * `hermosa s3 buckets`
  * `hermosa security group for VPC`
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-hermosa-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-base/badge.svg)

#### Admin ALB Architecture
![Admin ALB Architecture](docs/diagrams/admin_alb.png)

#### Web ALB Architecture
![Web ALB Architecture](docs/diagrams/web_alb.png)
_Note: `api.chownow.com` is used in the example, but this is the same setup for other hermosa web subdomains (`eat`, `facebook`, `ordering`, etc)_

_Note: In lower environments, the DNS zone will be `{ENV}.svpn.chownow.com`_
