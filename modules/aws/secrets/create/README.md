# Create Secrets

### General

* Description: A module to create secrets with random values in secrets manager. It creates a secret with the following format: `env/service/secret_key_name` (eg. `uat/dms/super_secret`)
* Created By: Joe Perez
* Module Dependencies: N/A
* Provider Dependencies: `aws`, `random`
* Terraform Version: 1.5.x

![aws-secret-create](https://github.com/ChowNow/ops-tf-modules/workflows/aws-secret-create/badge.svg)

### Usage

* Terraform:

* "Plaintext" Secret
```hcl
module "secret_name" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description = "super duper important secret"
  env         = "uat"
  secret_name = "secret_key_name"
  service     = "dms"
}
```

* Key/Value Secret
```hcl
module "secret_name" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description        = "super duper important secret"
  env                = "uat"
  secret_name        = "secret_key_name"
  secret_key         = "token"
  service            = "dms"
}
```

### Secret Retrieval

* Create a `data_source.tf` file in your module/workspace
* Add data source lookup for your secret:

```
data "aws_secretsmanager_secret" "secret_key_name" {
  name = "${var.env}/${var.service}/secret_key_name"
}

data "aws_secretsmanager_secret_version" "secret_key_name" {
  secret_id     = data.aws_secretsmanager_secret.secret_key_name.id
  version_stage = "AWSCURRENT"
}
```
* Reference that secret in another terraform file:

```
resource "aws_db_instance" "db" {
  ...
  ...
  ...
  password = data.aws_secretsmanager_secret_version.secret_key_name.secret_string

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name         | Description                               | Options                 |  Type  | Required? | Notes |
| :-------------------- | :---------------------------------------- | :---------------------- | :----: | :-------: | :---- |
| description           | description of secret                     | anything helpful        | string |    Yes    | N/A   |
| env                   | unique environment/stage name             |                         | string |    Yes    | N/A   |
| service               | service name                              | hermosa, flex, dms, etc | string |    Yes    | N/A   |
| secret_key            | required to create k/v secret             | any string              | string |    No     | N/A   |
| secret_name           | name for secret                           | anything helpful        | string |    Yes    | N/A   |
| enable_secret_version | allows to disable secret version creation | default: 1              |  int   |    No     | N/A   |

#### Outputs



### Lessons Learned
* We chose 32 character length because some products do not like special characters
* Ignoring changes to the key value so that we can change it without triggering terraform changes that might change it back


### References
