# Hermosa API on ECS

### General

* Description: Hermosa API on ECS. This module deploys a web service with IAM roles, security group to access Hermosa persistence layer and a target group associated with the ECS service.
* Created By: Sebastien Plisson
* Module Dependencies: `alb_ecs_tg`,`ecs_web_service`,`autoscale`,`ecs_service`,`ecs_configuration`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-api](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-api/badge.svg)
