# Datadog Agent App Module

### General

* Description: datadog agent for database monitoring
* Created By: DevOps
* Module Dependencies: `vpc`, `dd-agent-base`
* Provider Dependencies: `aws`

![chownow-services-dd-agent-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-dd-agent-app/badge.svg)

### Terraform

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── dd-agent
            └── app
                ├── dd_agent_app.tf
                ├── provider.tf
                └── variables.tf
```

* `dd_agent_app.tf`

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

module "dd_agent_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dd-agent/app?ref=cn-dd-agent-app-v2.0.2"

  for_each = toset(local.vpc_names)

  env      = var.env
  vpc_name = each.value
}
```

### Changelog

* Changing secrets manager config location to support multiple instances in single account


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

* These datadog agent logs stay in CloudWatch, on a 7 day retention. Felt a bit redundant to send the datadog agent logs to datadog. It's also easier to debug when these logs live in cloudwatch and you can see them more quickly via the ECS interface
* This is the one of times we've used ephemeral volumes and I'm hoping that this pattern can be extended to other services which don't consume secrets through environment variables
* Consolidating the deployment for each VPC into a single workspace seems better for maintenance, but there is a complexity hit because of the `for_each` loop on the module





* Connect to task: `aws-vault exec dev -- aws ecs execute-command --region us-east-1 --cluster $CLUSTER_NAME --task $TASK_ID --container $ECS_SERVICE_NAME --command "/bin/bash" --interactive`




### Resources

* https://docs.datadoghq.com/containers/docker/?tab=standard
* https://docs.datadoghq.com/integrations/ecs_fargate/?tab=webui#web-ui-task-definition
* https://www.datadoghq.com/blog/monitor-aurora-using-datadog/
* https://dev.to/aws-builders/how-to-integrate-datadog-agent-in-ecs-fargate-4cli
* https://docs.datadoghq.com/database_monitoring/setup_mysql/aurora/?tab=host#install-the-agent
