# Tenable base

### General

* Description: Tenable base
* Created By: Allen Dantes
* Module Dependencies: `vpc`, `tenable-base`
* Provider Dependencies: `aws`, `template`

![chownow-services-tenable-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-tenable-base/badge.svg)


### Terraform

* Run the tenable `base` module to create the secrets
```
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── tenable
            ├── app
            └── base
                ├── tenable_base.tf
                ├── provider.tf
                ├── iam.tf
                └── variables.tf
```

  * `tenable_base.tf`
```hcl
module "tenable_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/tenable/base?ref=cn-tenable-base-v2.0.3"

  env = var.env
}
```

* Update the API keys and secrets in AWS Secrets Manager and store them in 1PW

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options          |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :--------------- | :----: | :-------: | :---- |
| env           | unique environment/stage name | pde-stg pde-prod | string |    Yes    | N/A   |
| env_inst      | environment instance          | 00/01/02/...     | string |    No     | N/A   |
| service       | name of ECS service           | default: tenable | string |    No     | N/A   |

#### Outputs

### Lessons Learned

### References
