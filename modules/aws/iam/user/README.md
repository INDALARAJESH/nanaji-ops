# IAM User Account

### General

* Description: Modules that creates IAM users
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x, 1.5.x

![aws-iam-user-service](https://github.com/ChowNow/ops-tf-modules/workflows/aws-iam-user-service/badge.svg)
![aws-iam-user-human](https://github.com/ChowNow/ops-tf-modules/workflows/aws-iam-user-human/badge.svg)

### Usage

* Terraform:

* Service Account
```hcl
module "user_svc_jenkins" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/service?ref=aws-iam-user-service-v3.0.0"

  env      = "ncp"
  service  = "jenkins"
  user_policy = data.aws_iam_policy_document.jenkins_iam_user_policy.json
}
```

* Human Account
```hcl
module "user_joe_perez" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/iam/user/human?ref=aws-iam-user-human-v2.0.2"

  env        = "sb"
  first_name = "joe"
  last_name  = "perez"
  iam_groups = ["admins"]
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name     | Description                                | Options                      |     Type      | Required? | Notes                                    |
| :---------------- | :----------------------------------------- | :--------------------------- | :-----------: | :-------: | :--------------------------------------- |
| create_access_key | boolean flag to create iam user access key | 0 or 1 (default 0)           |      int      |    No     |                                          |
| env               | unique environment/stage name              | dev, ncp, prod, qa, stg, uat |    string     |    Yes    |                                          |
| env_inst          | environment/stage name count               | default ""                   |    string     |    No     |                                          |
| first_name        | user's first name (lowercase)              |                              |    string     |    Yes    | required when creating a human account   |
| last_name         | user's last name (lowercase)               |                              |    string     |    Yes    | required when creating a human account   |
| iam_groups        | list of groups to add human user to        |                              |     list      |    No     |                                          |
| service           | service related to service account         | dms, jenkins, etc            |    string     |    Yes    | required when creating a service account |
| user_policy       | rendered iam policy for service account    |                              | file/template |    Yes    | required when creating a service account |
| custom_path       | set iam user path                          |                              |               |    No     |                                          |
| custom_username   | set iam user name                          |                              |               |    No     |                                          |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References
