# User Privacy Service

### General

* Description: A module for user privacy service
* Created By: Ramalinga Patnala
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The user privacy service will process the Diner CCPA(OneTrust) request on real time basis for the below request types:
- Right To Know (Access My Information)
- Right To Delete (Delete My Account & Information) [for more details](https://chownow.atlassian.net/wiki/spaces/CE/pages/2708373594/RFC+User+Data+Requests+Service).

### Usage

* Terraform:

* user privacy Base Example (`user_privacy_base.tf`):
```hcl
module "user_privacy_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/user-privacy/base?ref=cn-user-privacy-base-v2.0.2"
  env    = var.env
  name   = "user-privacy"
  vpc_name_prefix = "nc"
}
```


* user data requests Service App Example (`user_privacy.tf`):
```hcl
module "user_privacy_app" {
  source    = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/user-privacy/app?ref=cn-user-privacy-app-v2.0.8"
  env       = var.env
  name      = "user-privacy"
  image_uri = "449190145484.dkr.ecr.us-east-1.amazonaws.com/user-privacy-service:731793ba3"
}
```

_Note:_
  - be sure to update the `Lambda's image_uri` tag with a valid tag, otherwise the lambda creation will fail
  - docker image must be pushed to ECR prior to creating / updating the Lambda setup

### Initialization

### Terraform

* Example directory structure:
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── user-privacy
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── user-privacy.tf
            │   └── provider.tf
            ├── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── user-privacy_base.tf
                └── provider.tf

```
## Deployment sequence with dependencies

### Terraform

* In new environment:
  * [all] `us-east-1/services/user-privacy/base`
  * [all] AWS Secrets Manager: Update secrets values with values from 1Password:
    - `one_trust_client_id` -- OneTrust Client ID to generate the API token
    - `one_trust_client_secret` -- OneTrust Client Secret to generate the API token
    - `user_privacy_service_api_key` -- used to authenticate(API gateway) the webhook request from OneTrust
    - `hermosa_api_key_user_privacy_lambda` -- used to connect to Hermosa API
  * [all] `us-east-1/services/user-privacy/app`

### Lessons Learned
