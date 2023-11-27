# Hermosa Standalone

### General

* Description: Hermosa ECS app terraform module. This module creates the ECS Services, ALBs and policy to run Hermosa and its depdendenices in containers on Fargate.
* Created By: Sebastien Plisson
* Module Dependencies: `aws_ecs_web_service`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-hermosa-ecs-standalone](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-ecs-standalone/badge.svg)

#### Admin ALB Architecture
![Admin ALB Architecture](docs/diagrams/admin_alb.png)

#### Web ALB Architecture
![Web ALB Architecture](docs/diagrams/web_alb.png)
_Note: `api.chownow.com` is used in the example, but this is the same setup for other hermosa web subdomains (`eat`, `facebook`, `ordering`, etc)_

_Note: In lower environments, the DNS zone will be `{ENV}.svpn.chownow.com`_

### Usage

* Terraform:

```hcl
module "hermosa_ecs_standalone" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-standalone?ref=hermosa-ecs-standalone-v2.1.0"

  env = "dev"
  alb_name_prefix = "on-demand-pub"
  cluster_name_prefix = "on-demand"
  alb_hostnames = ["admin.dev.svpn.chownow.com"]
}
```



### Initialization

### Terraform

* Run the Hermosa ecs-standalone module in `ecs-standalone` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── hermosa
            └── ecs-standalone
                ├── ecs.tf
                ├── alb.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                          | Description                                                                                                                                                 | Options/Default                 |  Type  | Required? | Notes |
| :------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------ | :----: | :-------: | :---- |
| domain                                 | public domain name information                                                                                                                              |                                 | string |    No     | N/A   |
| dns_ttl                                | dns records ttl                                                                                                                                             | 300                             | string |    No     | N/A   |
| env                                    | unique environment/stage name                                                                                                                               | dev/qa/prod/stg/uat             | string |    Yes    | N/A   |
| env_inst                               | iteration of environment                                                                                                                                    | eg 00,01,02,etc                 | string |    No     | N/A   |
| service                                | service name                                                                                                                                                | hermosa                         | string |    No     | N/A   |
| service_id                             | unique service identifier                                                                                                                                   |                                 | string |    No     | N/A   |
| alb_name_prefix                             | prefix of ALB name to attach rules and target group to                                                                                                      |                                 | string |    Yes    | N/A   |
| cluster_name_prefix                    | prefix of ECS cluster name to attach service to                                                                                                             |                                 | string |    Yes    | N/A   |
| custom_cluster_name                    | specific ECS cluster name to attach service to                                                                                                              |                                 | string |    No     | N/A   |
| custom_alb_name                        | specific ALB name to attach rules and target group to                                                                                                       |                                 | string |    No     | N/A   |
| alb_hostnames                          | list of records to allow for the alb                                                                                                                        | ["a","b","c", ...]              |  list  |    Yes    |       |
| wildcard_domain_prefix                 | allows for the addition of wildcard to the name because some chownow accounts have it                                                                       |                                 | string |    No     | N/A   |
| web_container_deregistration_delay     | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds | 30                              |  int   |    No     | N/A   |
| web_container_image_version            | the image version used to start the web container                                                                                                           | web-latest                      | string |    No     | N/A   |
| web_container_port                     | web container ingress TCP port                                                                                                                              | 443                             | string |    No     | N/A   |
| web_container_healthcheck_interval     | web container healthcheck interval                                                                                                                          | 15                              |  int   |    No     | N/A   |
| web_container_healthcheck_target       | web container healthcheck endpoint                                                                                                                          | /health                         | string |    No     | N/A   |
| web_ecr_repository_uri                 | ECR repository uri for the web container                                                                                                                    |                                 | string |    Yes    | N/A   |
| web_ecs_service_desired_count          | desired number of web task instances to run                                                                                                                 | 1                               |  int   |    No     | N/A   |
| web_ecs_service_max_count              | max number of web task instances to run                                                                                                                     | 10                              |  int   |    No     | N/A   |
| task_container_image_version           | the image version used to start the task container                                                                                                          | task-latest                     | string |    No     | N/A   |
| task_ecr_repository_uri                | ECR repository uri for the task container                                                                                                                   |                                 | string |    Yes    | N/A   |
| task_ecs_service_desired_count         | desired number of task task instances to run                                                                                                                | 1                               |  int   |    No     | N/A   |
| task_ecs_service_max_count             | max number of task task instances to run                                                                                                                    | 10                              |  int   |    No     | N/A   |
| mysql_container_image_version          | the image version used to start the mysql container                                                                                                         |                                 | string |    No     | N/A   |
| mysql_ecr_repository_uri               | ECR repository uri for the mysql container                                                                                                                  |                                 | string |    No     | N/A   |
| redis_container_image_version          | the image version used to start the redis container                                                                                                         |                                 | string |    No     | N/A   |
| redis_ecr_repository_uri               | ECR repository uri for the redis container                                                                                                                  |                                 | string |    No     | N/A   |
| elasticsearch_container_image_version  | the image version used to start the elasticsearch container                                                                                                 |                                 | string |    No     | N/A   |
| elasticsearch_ecr_repository_uri       | ECR repository uri for the elasticsearch container                                                                                                          |                                 | string |    No     | N/A   |
| config_container_image_version         | the image version used to start the config container                                                                                                        |                                 | string |    No     | N/A   |
| config_ecr_repository_uri              | ECR repository uri for the config container                                                                                                                 |                                 | string |    No     | N/A   |
| firelens_container_name                | firelens container name"                                                                                                                                    | log_router                      | string |    No     | N/A   |
| firelens_container_ssm_parameter_name" | firelens container ssm parameter name                                                                                                                       | /aws/service/aws-for-fluent-bit | string |    No     | N/A   |
| firelens_container_image_version"      | firelens container image version (tag)                                                                                                                      | 2.10.1                          | string |    No     | N/A   |


### Lessons Learned


### References
