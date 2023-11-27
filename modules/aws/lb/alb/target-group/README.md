# ALB Target Group

### General

* Description: A module to create an ALB Target Group
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-alb-target-group](https://github.com/ChowNow/ops-tf-modules/workflows/aws-alb-target-group/badge.svg)

### Usage


* Target group:

```hcl
module "admin_hermosa_tg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  alb_name             = module.admin_hermosa_alb.alb_name
  env                  = var.env
  service              = "hermosa"
  vpc_id               = data.aws_vpc.selected.id

}
```

* Target Group with custom suffix:

```hcl
module "admin_hermosa_tg_ck" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/target-group?ref=aws-alb-tg-v2.0.1"

  alb_name             = module.admin_hermosa_alb.alb_name
  env                  = var.env
  service              = "hermosa"
  name_suffix          = "ck"
  vpc_id               = data.aws_vpc.selected.id

}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name          | Description                          | Options                                  | Type   | Required? | Notes |
| :--------------------- | :----------------------------------- | :--------------------------------------- | :----: | :-------: | :---- |
| env                    | unique environment/stage name        |                                          | string |  Yes      | N/A   |
| service                | service name                         | hermosa, flex, etc                       | string |  Yes      | N/A   |
| target_group_name      | target group name                    |                                          | string |  No       | N/A   |
| name_suffix            | target group name suffix             |                                          | string |  No       | N/A   |

#### Outputs

| Variable Name      | Description         | Type    | Notes |
| :----------------- | :------------------ | :-----: | :---- |


### Lessons Learned


### References

* [Terraform conditional output issue](https://github.com/hashicorp/terraform/issues/12453)
