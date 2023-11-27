# Sysdig Secure - Cloud Organizational Account

### General

* Description: This uses the Sysdig Terraform module for setting up an orginzational AWS acccount connection to Sysdig Secure.
* Created By: Jobin Muthalaly
* Module Dependencies:
  * `sysdiglabs/secure-for-cloud/aws//examples/organizational`
* Provider Dependencies: `aws`, `sysdig`
* Terraform Version: 1.5.0
* AWS Provider Version: ~> 5.0.1

![chownow-services-sysdig-secure-cloud-organizational](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-sysdig-secure-cloud-organizational/badge.svg)

### Usage, Latest Version

* Terraform:

```hcl
module "sysdig_secure_cloud_organizational" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/sysdig-secure/cloud/organizational?ref=cn-sysdig-secure-cloud-org-v3.0.0"

  env = var.env
}
```


### Terraform

* Example directory structure: `ops/terraform/environments/mgmt/us-east-1/services/sysdig-secure`
```
├── cloud
│   ├── env_global.tf -> ../../../../env_global.tf
│   ├── sysdig_secure_cloud.tf
│   ├── variables.tf
│   └── provider.tf
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                     | Options      |  Type  | Required? | Notes |
| :-----------------------| :-------------------------------| :----------- | :----: | :-------: | :---- |
| env                     | unique environment/stage name   | ex: "dev"    | string | Yes       | N/A   |



#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned

* This module is using a separate Terraform module provided by Sysdig, changes may be required here in the future if Sysdig makes updates to their module.
