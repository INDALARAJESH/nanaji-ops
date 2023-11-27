# Datadog Agent base Module

### General

* Description: datadog agent for database monitoring
* Created By: DevOps
* Module Dependencies: `vpc`, `dd-agent-base`
* Provider Dependencies: `aws`

![chownow-services-dd-agent-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-dd-agent-base/badge.svg)

### Terraform

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── dd-agent
            └── base
                ├── dd_agent_base.tf
                ├── provider.tf
                └── variables.tf
```

* `dd_agent_base.tf`

```hcl
data "aws_vpcs" "in_region" {}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.in_region.ids)
  id = each.value
}

variable "excluded_vpc_list" {
    description = "list of VPCs to exclude from provisioning"
    default = ["do-not-use"]
}

locals {
    vpc_map = { for vpc_id,vpc_info in data.aws_vpc.selected :
                    vpc_info.tags["Name"] => vpc_id }
    vpc_names = [for vpc_name,vpc_id in local.vpc_map :
                    vpc_name if ! contains(var.excluded_vpc_list, vpc_name)]
}

module "dd_agent_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dd-agent/base?ref=cn-dd-agent-base-v2.0.0"

  for_each = toset(local.vpc_names)

  env      = var.env
  vpc_name = each.value
}
```

### Post-Terraform Configuration

1. You will need to follow the datadog instructions on the database you want to send metrics from. This is most likely creating a user on the database called `datadog` and give it permissions to pull metrics. Links can be found under the `Resources` heading
2. You will need to create a config file for the databases you want to monitor in that specific VPC, eg:

`database.conf`
```yaml
init_config:

instances:
  - dbm: true
    host: 'db-master.dev.aws.chownow.com'
    port: 3306
    username: datadog
    password: 'REALPASSWORDGOESHERE'
    tags:
      - 'env:dev'
      - 'service:hermosa-mysql'
  - dbm: true
    host: 'db-replica.dev.aws.chownow.com'
    port: 3306
    username: datadog
    password: 'REALPASSWORDGOESHERE'
    options:
      replication: true
    tags:
      - 'env:dev'
      - 'service:hermosa-mysql'

```
3. You will need to base64 encode this file to retain the formatting (THIS IS NOT ENCRYPTING), eg: `base64 -i database.conf`
4. You will update the secret value for that specific VPC (eg. `dev/dd-agent/config-main-dev`)
5. After the secret has been updated, you can move forward with deploying the `app` module

_**NOTE**: Any updates to this config would require pulling the base64 encoded config from secrets manager, decoding the file, updating it, encoding it again, updating secrets manager, and redeploying the dd-agent service._

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name   | Description                   | Options               |  Type  | Required? | Notes |
| :-------------- | :---------------------------- | :-------------------- | :----: | :-------: | :---- |
| env             | unique environment/stage name | pde-stg pde-prod      | string |    Yes    | N/A   |
| env_inst        | environment instance          | 00/01/02/...          | string |    No     | N/A   |
| service         | name of ECS service           | default: dd-agent     | string |    No     | N/A   |
| vpc_name        | vpc name                      | ex: main              | string |    Yes    | N/A   |






### Lessons Learned


* Trying to consolidate the usage of the secrets module by using a for loop. Iteration seems pretty quick compared to individually defining each secret, but at the cost of additional complexity
* The Datadog documentation is trash, finding what you need to get this working on ECS is a joke





Connect to task: `aws-vault exec dev -- aws ecs execute-command --region us-east-1 --cluster $CLUSTER_NAME --task $TASK_ID --container $ECS_SERVICE_NAME --command "/bin/bash" --interactive`




### Resources

* https://docs.datadoghq.com/containers/docker/?tab=standard
* https://docs.datadoghq.com/integrations/ecs_fargate/?tab=webui#web-ui-task-definition
* https://www.datadoghq.com/blog/monitor-aurora-using-datadog/
* https://dev.to/aws-builders/how-to-integrate-datadog-agent-in-ecs-fargate-4cli
* https://docs.datadoghq.com/database_monitoring/setup_mysql/aurora/?tab=host#install-the-agent
