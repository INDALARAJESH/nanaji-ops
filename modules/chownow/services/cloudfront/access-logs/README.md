# Cloudfront Access Logs

### General

* Description: Cloudfront S3 Access Logs
* Created By: Allen Dantes
* Module Dependencies: N/A
* Provider(s): `aws`

### Usage

* Terraform (basic):

```hcl
module "s3_access_logs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/access-logs?ref=s3-access-logs-v2.0.0"

  env       = var.env
  env_inst  = var.env_inst
}
```

## Module Options


### Inputs


| Variable Name             | Description                                                      | Options                         |  Type   | Required? | Notes        |
| ------------------------- | ---------------------------------------------------------------- | ------------------------------- | ------- | --------- | ------------ |
| env                       | unique environment/stage name                                    | uat, dev, qa, stg, prod         | string  | Yes       | N/A          |
| env_inst                  | environment instance, eg 01 added to stg01                       | depends on env (defaults to "") | string  | No        | N/A          |


## Notes
