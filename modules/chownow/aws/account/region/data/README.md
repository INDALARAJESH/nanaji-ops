# AWS Region Base

### General

* Description: A module to create the required AWS IAM role for Dna data-serverless lambdas:
   
  * IAM Role specific to Lamda
  * Created By: Swaminathan Bala
  * Provider Dependencies: `aws`
  * Terraform Version: 0.14.x

![aws-region-data](https://github.com/ChowNow/ops-tf-modules/workflows/aws-region-data)

### Usage

* Terraform:

`ops>terraform>environments`
```
env
├── global
│   └── base
└── us-east-1
    └── data
        ├── data.tf
        ├── provider.tf
        └── env_global.tf
```

* Region base example

`base.tf`
```hcl
module "useast1_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/aws/account/region/data?ref=cn-aws-region-data-v1.0.1"

  env = "data"

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name               | Description                                                        | Options             |  Type  | Required? | Notes |
| :-------------------------- | :----------------------------------------------------------------- | :------------------ | :----: | :-------: | :---- |
| env                         | unique environment/stage name                                      |                     | string |    Yes    | N/A   |
| env_inst                    | environment instance number                                        | 1...n               | string |    No     | N/A   |
| aws_account_id              | account id to create                                               |                     | string |    Yes    | N/A   |
| aws_assume_role_name        | aws assume role name                                               |                     | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Lessons Learned


### References
