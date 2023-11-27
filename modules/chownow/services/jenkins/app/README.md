# Jenkins

### General

* Description: Jenkins app
* Created By: DevOps
* Module Dependencies: `aws-ec2-basic`, `jenkins-base`
* Provider Dependencies: `aws`

![chownow-services-jenkins-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-jenkins-app/badge.svg)

### Terraform

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── jenkins
            └── app
                ├── env_global.tf -> ../../../../env_global.tf
                ├── jenkins.tf
                └── provider.tf
```
* `jenkins.tf`

```hcl
module "jenkins" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/jenkins/app?ref=cn-jenkins-app-v2.0.3"

  env = var.env
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options          |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :--------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | pde-stg pde-prod | string |    Yes    | N/A   |
| instance_type | ec2 instance type             |                  | string |    No     | N/A   |



#### Outputs


### Lessons Learned

* Changing the ec2 service tag from "Jenkins" to the correct "jenkins" results in a destroy of IAM resources that is not worth the risk with only one Jenkins deployment

### References

Tested with:
terraform plan
