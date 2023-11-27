# ALB in svpn zone Module

### General

* Description: Creates an ALB in a svpn DNS zone
* Created By: Sebastien Plisson
* Module Dependencies: `alb-public`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-svpn-alb](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-svpn-alb/badge.svg)


### Usage

* Terraform (basic):

```hcl
module "on_demand" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//chownow/services/svpn-alb?ref=svpn-alb-v2.0.3"

  env                 = "qa"
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
        └── on-demand
            ├── svpn-alb.tf
            ├── provider.tf
            └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                | Description                                    | Options             |  Type  | Required? | Notes |
|:-----------------------------|:-----------------------------------------------|:--------------------|:------:|:---------:|:------|
| env                          | unique environment/stage name                  | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| service                      | service name                                   | on-demand           | string |    No     | N/A   |
| env_inst                     | environment instance                           | 00/01/02/...        | string |    No     | N/A   |
| vpc_name_prefix              | vpc prefix for alb placement                   | main                | string |    No     | N/A   |
| security_group_name_override | specific security group name for alb placement | main-vpn-sg-dev     | string |    No     | N/A   |

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


### References
