# AWS Key Pair

### General

* Description: This module creates an EC2 key pair for a given AWS region
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`

![aws-key-pair-basic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-key-pair-basic/badge.svg)

### Usage

* Terraform:

```hcl
module "key_pair" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/key-pair/basic?ref=aws-key-pair-basic-v2.0.0"

  env         = var.env

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume


#### Inputs

| Variable Name              | Description                            | Options                         | Type     | Required? | Notes |
| :------------------------- | :------------------------------------- | :------------------------------ | :------: | :-------: | :---- |
| env                        | unique environment/stage name          | sandbox/dev/qa/uat/stg/prod/etc | string   |  Yes      | N/A   |
| custom_key_pair_name       | overrides default naming pattern       |                                 | string   |  No       | N/A   |
| custom_key_public_key      | overrides module public keys           |                                 | string   |  No       | N/A   |

#### Outputs

| Variable Name      | Description           | Type    | Notes |
| :----------------- | :-------------------- | :-----: | :---- |
| key_pair_id        | key pair ID / Name    | string  | N/A   |


### Lessons Learned

* Figuring out when/where to create the key pair is a pain.
  * If you embed the key pair with the ec2 module, you need to make sure there's no adjacent (blue/green) module trying to create the same key pair
  * If you separate the key pair from the ec2, but keep it in the same service module, you need to make sure it's ordered correctly
  * Key pairs are region-specific, so it can be created at the region level, but it's not that intuitive that the key pair was created there
* **We've settled on adding this key pair module to the Region Base module**

### References
