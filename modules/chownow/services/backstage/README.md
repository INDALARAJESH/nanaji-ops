Backstage Infrastructure
==================================

### General

* Description: Contains All related infrastructure code for deploying a backstage application.
* Created By: Alex Boyd
* Module Dependencies: `alb-public`, `alb_ecs_tg`, `alb_ecs_listener_rule` `alb_origin_r53`, `ecs_base`,`ecs_service`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

### Submodules

##### base

Contains all infrastructure supporting backstage such as creating an ECR repo.


backstage uses ECR to store the docker images built during our CI/CD process.

The repo name generated in `backstage-<env>` form (ex: `backstage-dev`)

By default, tagging an image a certain way will keep the image around stored for longer.

| Image Tag Prefix (upper\lower cased)     | # of Images Stored |
| ------- | -------- |
| v       | 30       |
| cn-     | 30       |
| base-   | 10       |
| pr-     | 30       |
| develop-| 15       |
| staging-| 15       |
| No tag  | 5       |

##### db

Contains an RDS PostgreSQL component supporting backstage

##### app

Contains all related infrastructure to get backstage running on ECS fargate including:

- Creating an ALB
