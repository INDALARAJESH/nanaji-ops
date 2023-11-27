# Errbot

### General

* Description: Errbot V2 Terraform Module
* Created By: Allen Dantes
* Module Dependencies: `vpc`, `errbot-base`
* Provider Dependencies: `aws`, `template`

### Terraform

* Run the Errbot `base` module to create the secrets
```
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── errbot
            ├── app
            └── base
                ├── errbot_base.tf
                ├── backend.tf
                └── variables.tf
```

  * `errbot_base.tf`
```hcl
module "errbot_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/errbot/base?ref=cn-errbot-base-v2.0.3"

  env = var.env
}
```

* Update the API keys and secrets in AWS Secrets Manager and store them in 1PW

* Run the Errbot app module to create ECS/ECR/etc
  * eg directory structure

```hcl
ops/
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── errbot
            └── app
                ├── errbot_app.tf
                ├── provider.tf
                └── variables.tf
```
* `errbot_app.tf`

```hcl
module "errbot_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/errbot/app?ref=cn-errbot-app-v2.0.2"

  env           = var.env
  image_version = "some-container-tag-goes-here"
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name  | Description                   | Options          |  Type  | Required? | Notes |
| :------------- | :---------------------------- | :--------------- | :----: | :-------: | :---- |
| container_port | ECS container port            | TCP port         | string |    No     | N/A   |
| env            | unique environment/stage name | pde-stg pde-prod | string |    Yes    | N/A   |
| service        | name of ECS service           | default: errbot  | string |    No     | N/A   |



#### Outputs


### Lessons Learned


### References

* [Errbot App](https://github.com/ChowNow/ops-serverless/tree/master/errbot)
