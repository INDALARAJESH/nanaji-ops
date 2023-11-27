# Module to create ALB and ECS cluster in svpn zone

### General

* Description: Creates an ALB and ECS cluster in a svpn DNS zone
* Created By: Warren Nisley
* Module Dependencies: `alb-public` `ecs-cluster`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-alb-ecs-cluster](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-alb-ecs-cluster/badge.svg)


### Usage

* Terraform (basic):

```hcl
module "alb-ecs-cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/alb-ecs-cluster?ref=alb-ecs-cluster-v2.0.2"

  env = "qa"
}
```

### Initialization

### Terraform

* Run the Hermosa base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── alb-ecs-cluster
            ├── app.tf
            ├── provider.tf
            └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                | Description                                    | Options                  |  Type  | Required? | Notes |
|:-----------------------------|:-----------------------------------------------|:-------------------------|:------:|:---------:|:------|
| env                          | unique environment/stage name                  | dev/qa/prod/stg/uat      | string |    Yes    | N/A   |
| service                      | service name                                   | on-demand                | string |    No     | N/A   |
| env_inst                     | environment instance                           | 00/01/02/...             | string |    No     | N/A   |
| vpc_name_prefix              | vpc prefix for alb placement                   | main                     | string |    No     | N/A   |
| security_group_name_override | specific security group name for alb placement | main-vpn-sg-dev          | string |    No     | N/A   |
| listener_da_type             | listener type                                  | forward or fixed-response| string |    No     | N/A   |
| tg_target_type               | target group type                              | ip or instance           | string |    No     | N/A   |


#### Outputs

| Variable Name | Description          |  Type  | Notes |
| :------------ | :------------------- | :----: | :---- |
| alb_arn       | ALB ARN              | string | N/A   |
| alb_name      | ALB name             | string | N/A   |
| alb_tg_arn    | ALB target group ARN | string | N/A   |
| alb_dns_name  | ALB DNS name         | string | N/A   |
| listener_arn  | ALB listener ARN     | string | N/A   |
| listener_port | ALB listener port    | string | N/A   |
| cluster_id    | ECS cluster id       | string | N/A   |
| cluster_name  | ECS cluster name     | string | N/A   |


### Lessons Learned


### References
