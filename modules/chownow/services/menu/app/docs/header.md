# Menu Service on ECS

### General

* Description: Menu Service on ECS. This module deploys an API service with IAM roles.
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `ecs`, `autoscale`, `ecs_task`
* Module Components:
  * `ecs_base_web`
  * `ecs_base_autoscale`
  * `ecs_td_manage`
* Providers : `aws`, `random`
* Terraform Version: 0.14.6

![menu-service-infra](https://github.com/ChowNow/menu-service/blob/1959b29bf6842ac3c73b0dad1137015696d981a1/diagrams/menu_service_infra_20220825.png)
