### General

* Description: A module to create a cloudwatch log group with authorizations
* Created By: Sebastien Plisson
* Module Dependencies: `None`

![aws-cloudwatch-log-group](https://github.com/ChowNow/ops-tf-modules/workflows/aws-cloudwatch-log-group/badge.svg)

### Usage

```hcl
module "log_group" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.3"
  env    = var.env
}
```

#### Inputs

| Variable Name     | Description               | Options                  | Type   | Required? | Notes |
| ----------------- | ------------------------- | ------------------------ | ------ | --------- | ----- |
| env               | environment/stage         | uat, qa, qa00, stg, prod | string | Yes       | N/A   |
| env_inst          | environment instance      | 00, 01, 02               | string | No        | N/A   |
| path              | Path of log group         | N/A                      | string | Yes       | N/A   |
| name              | Name of log group         | N/A                      | string | Yes       | N/A   |
| kms_key_id        | KMS key to encrypt logs   | default: null            | string | No        | N/A   |
| retention_in_days | days to retain log events | default: 0 means forever | int    | No        | N/A   |

#### Outputs

#### Notes
