# ECS Cluster

### General

* Description: A module to create an ECS cluster
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`

![aws-ecs-cluster](https://github.com/ChowNow/ops-tf-modules/workflows/aws-ecs-cluster/badge.svg)
### Usage

* Terraform:

```hcl
module "ecs_cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/cluster?ref=aws-ecs-cluster-v2.0.0"

  env     = var.env
  service = "dms"
}
```


* Querying the Cluster ID/ARN from another module:

```hcl

data "aws_ecs_cluster" "app" {
  cluster_name = "${var.service}-${local.env}"
}
```
_Note: this is if you don't override the name with the `custom_cluster_name` parameter_

* Using in module parameter: `cluster = data.aws_ecs_cluster.app.arn`




### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name             | Description                         | Options                        |  Type  | Required? | Notes |
| :------------------------ | :---------------------------------- | :----------------------------- | :----: | :-------: | :---- |
| custom_cluster_name       | override for default cluster name   | (default: "")                  | string |    No     | N/A   |
| ecs_cluster_setting_name  | key for container insights option   | (default: "containerInsights") | string |    No     | N/A   |
| ecs_cluster_setting_value | value for container insights option | (default: "enabled")           | string |    No     | N/A   |
| env                       | unique environment/stage name       |                                | string |    Yes    | N/A   |
| service                   | service name                        | hermosa, flex, etc             | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description      |  Type  | Notes |
| :------------ | :--------------- | :----: | :---- |
| cluster_id    | ECS Cluster ID   | string |       |
| cluster_name  | ECS Cluster name | string |       |


### Lessons Learned

* The ECS cluster resource should live in a service's `base` module to allow you to swap out the service more easily and to allow canary deployments.


### References
