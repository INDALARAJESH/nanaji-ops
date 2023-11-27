# appsmith Service App

### General

* Description: appsmith Service app terraform module
* Created By: Anshul Puri
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-appsmith-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-appsmith-base/badge.svg)


### Usage

* Terraform (app module deployment):

```hcl
module "appsmith_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appsmith/app?ref=cn-appsmith-app-v2.3.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```

* Host volume example:

```hcl
locals {
  host_volumes = [
    {
      name = "efs"
      efs_volume_configuration = [{
        file_system_id          = data.aws_efs_file_system.selected.file_system_id
        root_directory          = "/"
        transit_encryption      = "ENABLED"
        transit_encryption_port = 2999
      }]

    }
  ]

  runtime_platform = [{
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }]
}
```

### Initialization


### Terraform

* Run the appsmith service app module in `appsmith/base` folder
* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── appsmith
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── appsmith_app.tf
            │   └── provider.tf
            └── base
```


### Inputs

| Variable Name                 | Description                             | Options                  |  Type  | Required? | Notes          |
| :---------------------------- | :----------------------------           | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name           | dev/qa/prod/stg/uat/data | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                | eg 00,01,02,etc          | string |    No     | N/A            |
| service                       | service name                            | appsmith            | string |    Yes    | N/A            |



### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

We switched to using the cluster for NCP instead of EC2. The URI is a secretsmanager value constructed like this: https://www.mongodb.com/docs/manual/reference/connection-string/

These docs https://github.com/ChowNow/ops-tf-modules/tree/master/modules/aws/ec2/mongodb were followed with slight modifications to get the Database running properly. The main change is the appsmith table, called appsmithdb, had to be added to the list of databases for admin control for the appsmith admin user, e.g. { "role" : "clusterAdmin", "db" : "appsmithdb" } in addition to what's written there. Users and logins were all stored in secretsmanager.

Debugging was done by searching for appsmith-web in DataDog. That was the only way to get real feedback.

Required a Cloudflare entry. Cache issues can be a huge problem for debugging here. Clear your cache and ask other people to try hitting the appsmith URL.


### Resources

* [appsmith - RFC](https://google.com)
