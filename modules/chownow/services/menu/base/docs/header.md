# Menu Service Base TF Module

### General

* Description: Menu Service base terraform module. This module creates the web ALBs and other resources which are required before creating the hermosa application and database
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `alb-public`, `alb-listener-rule` `alb-target-group`, `route53`, `ecr`, `secrets`
* Module Components:
  * `alb_web`
  * `alb_tg`
  * `alb_listener_rule_default`
  * `alb_cname`
  * `jwt_auth_secret`
  * `ld_sdk_key_secret`
* Providers : `aws`, `random`
* Terraform Version: 0.14.6
