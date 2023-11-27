# Cocina React Storybook Base Module

### General

* Description: [Cocina React Storybook](https://chownow.atlassian.net/wiki/spaces/CE/pages/2810576997/Cocina+React+Library) base terraform module.
* Created By: Neal Patel
* Module Dependencies:
  - `aws_s3_bucket`
* Module Components: `S3`
* Providers : `aws`
* Terraform Version: 0.14.x


### Usage

* Terraform (basic):

```hcl
module "cocina-react--storybook-base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/cocina-react-storybook/base?ref=cn-cocina-react-storybook-base-v2.0.0"

  env      = "dev"
  env_inst = ""
}
```

### Initialization

### Terraform

* Run the Cocina React Storybook base module in `base` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── cocina-react-storybook
            └── base
                ├── cocina_react_base.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                               | Options             |  Type  | Required? | Notes          |
| :---------------------------- | :---------------------------------------- | :------------------ | :----: | :-------: | :------------- |
| env                           | unique environment/stage name             | dev/qa/prod/stg/uat | string |    Yes    | N/A            |
| env_inst                      | iteration of environment                  | eg 00,01,02,etc     | string |    No     | N/A            |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned

### References
