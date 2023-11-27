# Create a KMS Customer Managed Key

### General

* Description: A module to create a KMS Customer Managed Key
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-kms](https://github.com/ChowNow/ops-tf-modules/workflows/aws-kms/badge.svg)

### Usage

* Terraform:

```hcl
module "kms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/kms?ref=aws-kms-v2.0.1"

  env             = "dev"
  key_name_prefix = "cn"
  key_name        = "facebook-integration"

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                       | Options                                        |  Type  | Required? | Notes |
| :------------------ | :-------------------------------- | :--------------------------------------------- | :----: | :-------: | :---- |
| key_name            | key name                          |                                                | string |    Yes    |       |
| key_name_prefix     | key name prefix                   |                                                | string |    No     | N/A   |
| is_enabled          | key enabled                       | default: true                                  |  bool  |    No     | N/A   |
| is_rotation_enabled | key rotation enabled              | default: false                                 |  bool  |    No     | N/A   |
| aws_account_id      | account id to create kms users in |                                                | string |    Yes    |       |
| env                 | unique environment/stage name     |                                                | string |    Yes    | N/A   |
| env_inst            | environment instance number       | 1...n                                          | string |    No     | N/A   |
| principals          | allow to use the key              | { Service = ["logs.us-east-1.amazonaws.com"] } | array  |    No     | N/A   |

#### Outputs



### Lessons Learned
* CAA records need to exist in the local route53 DNS Zone!!!
* You need to make sure there are forwarders in the production account to point to the account you're working in!
* Certificate validation in the AWS Console and Terraform can take more than 30 minutes!!!

### References
