# Create Secrets

### General

* Description: A module to create secrets manager secrets via input value. This modules intent is to create secrets using outputs from adjacent modules.
* Created By: Tim Ho
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-secret-insert](https://github.com/ChowNow/ops-tf-modules/workflows/aws-secret-insert/badge.svg)
### Usage

* Terraform (plain text password):

```hcl
resource "random_password" "master_password" {
  length  = 32
  special = false
}

module "plaintext_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  secret_description = "secret description"
  secret_name        = "${var.env}/${var.service}/db_master_password"
  secret_plaintext   = random_password.master_password.result
  service            = var.service
}
```

* Terraform (key/value password):

```hcl
module "kv_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  is_kv              = true
  secret_description = "secret description"
  secret_name        = "${var.env}/${var.service}/kv"
  secret_kv          = { "key" = module.postgres_rds.pgmaster_password }
  service            = var.service
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                   | Options                     | Type       | Required? | Notes |
| :------------------- | :---------------------------  | :-------------------------- | :--------: | :-------: | :---- |
| env                  | unique environment/stage name |                             | string     |  Yes      | N/A   |
| is_kv                | boolean if secret is kv       |                             | string     |  Yes      | N/A   |
| secret_description   | description of secret         | anything helpful            | string     |  Yes      | N/A   |
| secret_name          | secretsmanager secret name    | valid secretsmanager path   | string     |  Yes      | N/A   |
| secret_kv            | kv secret value               | secret value                | map        |  No       | N/A   |
| secret_plaintext     | plaintext secret value        | secret value                | string     |  No       | N/A   |
| service              | service name                  | hermosa, flex, dms, etc     | string     |  Yes      | N/A   |

* Note: `secret_kv` and `secret_plaintext` are mutually exclusive inputs, both defaulting to their respective falsy values. They should match up canonically with `is_kv` i.e. is_kv = false, secret_plaintext = "foobar" or is_kv = true, secret_kv = { "foo" = "bar"}


#### Outputs

| Variable Name    | Description            | Type   | Notes |
| ---------------- | ---------------------- | ------ | ----- |
| secret_arn       | secrets manager arn    | string | N/A   |
