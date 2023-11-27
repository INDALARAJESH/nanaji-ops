# Jenkins

### General

* Description: Jenkins base
* Created By: DevOps
* Module Dependencies: `aws-r53-record-basic`
* Provider Dependencies: `aws`

![chownow-services-jenkins-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-jenkins-base/badge.svg)

### Terraform

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── jenkins
            └── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── jenkins.tf
                └── provider.tf
```
* `jenkins.tf`

```hcl
module "jenkins" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/jenkins/base?ref=cn-jenkins-base-v2.0.5"

  env = var.env
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options          |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :--------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | pde-stg pde-prod | string |    Yes    | N/A   |



#### Outputs


### Lessons Learned


### References

Tested with:
terraform plan
