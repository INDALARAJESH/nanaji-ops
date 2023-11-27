# Matillion App

### General

* Description: This module creates the ec2 instance(s) and related resources for the matillion application
* Created By: Joe Perez
* Module Dependencies: `aws-core-base`, `aws-region-base`
* Module Components: `aws-ec2-basic`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-matillion-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-matillion-app/badge.svg)
### Usage

* Terraform:

```hcl
module "matillion_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/matillion/app?ref=matillion-app-v2.0.9"

  env = "data"
}
```



### Initialization

### Terraform

* Run the Matillion base module in `base` folder
* Run the Matillion app module in the `app` folder
* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── matillion
            └── app
                ├── matillion_app.tf
                ├── provider.tf
                └── variables.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                           | Options                  |  Type  | Required? | Notes |
| :-------------------------------- | :------------------------------------ | :----------------------- | :----: | :-------: | :---- |
| custom_ami                        | override ami lookup for matillion ami | AMI ID                   | string |    No     | N/A   |
| env                               | unique environment/stage name         | dev/qa/prod/stg/uat/data | string |    Yes    | N/A   |
| env_inst                          | iteration of environment              | eg 00,01,02,etc          | string |    No     | N/A   |
| service                           | service name                          | matillion                | string |    No     | N/A   |
| sns_to_slack_lambda_function_name | lambda name                           |                          | string |    No     | N/A   |
| sns_to_slack_topic_name           | topic name                            |                          | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


* You can ssh into this instance by
  * creating a jumpbox in the same vpc
  * copy environment specific key in 1pw to the jumpbox s3 bucket (eg. `cn-jumpbox-data`)
  * start an aws session manager session for the jumpbox
  * copy the private key to the machine (eg. `aws s3 cp s3://cn-jumpbox-data/KEYNAMEGOESHERE ~/`)
  * go the home dir: `cd ~/`
  * change permissions on key: `chmod 600 KEYNAMEGOESHERE`
  * ssh into the matillion instance: `ssh -i KEYNAMEGOESHERE centos@INSTANCEPRIVATEIP`


### References

* [Matillion Infrastructure - Confluence](https://chownow.atlassian.net/wiki/spaces/CE/pages/2066612405/Matillion+Infrastructure)
* [Matillion Instance Sizing](https://documentation.matillion.com/docs/1991961)
* [Launching Matillion ETL using Amazon Machine Image](https://documentation.matillion.com/docs/2568307)
