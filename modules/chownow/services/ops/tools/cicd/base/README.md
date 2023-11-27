# CI/CD Secrets Module

### General

* Description: This module supplies secrets that Codebuild needs during the CI/CD pipeline
* Created By: Eric Tew
* Module Dependencies:
  * `aws-secrets-insert`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Usage

* Terraform:

```
module "cicd" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/tools/cicd/base?ref=chownow-cicd-base-v2.0.1"

  env = "uat"

}
```


### Inputs

| Variable Name          | Description                  | Options                             | Type   | Required? | Notes |
| ---------------------- | ---------------------------- | ----------------------------------- | ------ | --------- | ----- |
| service                | name of app/service          | default: cicd           | string | Yes       | N/A   |
| tag_managed_by         | managed by tag               | name (default: `Terraform`)         | string | No        | N/A   |



### Outputs

| Variable Name | Description | Type | Notes |
| ------------- | ----------- | ---- | ----- |



### Lessons Learned

### Resources

