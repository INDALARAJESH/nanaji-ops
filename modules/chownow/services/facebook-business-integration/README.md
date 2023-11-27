# Facebook business integration service

### General

* Description: A module to create a Facebook business integration service
* Created By: Sebastien Plisson
* Module Dependencies:
  * `region-base`
  * `channels-api`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-fbe-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-fbe-base/badge.svg)
![chownow-services-fbe-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-fbe-app/badge.svg)

### Usage

* Terraform:

* Facebook Integration Base Example (`fbe_base.tf`):
```hcl
module "fbe_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/facebook-business-integration/base?ref=cn-fbe-base-v2.0.0"

  env = "dev"
}
```

* Facebook Integration App Example (`fbe_app.tf`):
```hcl
module "fbe_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/facebook-business-integration/app?ref=cn-fbe-app-v2.0.5"

  env              = "dev"
  lambda_image_uri = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/fbe:db2dcb0"
}
```
_Note: be sure to update the `lambda_image_uri` tag with a valid tag, otherwise the lambda creation will fail_


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
        ├── channels-api
        └── facebook-business-integration
            ├── app
            │   ├── env_global.tf -> ../../../../env_global.tf
            │   ├── fbe_app.tf
            │   └── provider.tf
            └── base
                ├── env_global.tf -> ../../../../env_global.tf
                ├── fbe_base.tf
                └── provider.tf
```
## Deployment sequence with dependencies
### AWS Console

* [lower_env] Allowed terraform-ncp to assume other accounts:
  * In ops: https://console.aws.amazon.com/iamv2/home#/groups/details/ncp-account-admins?section=permissions
* [lower_env] Allowed ncp account to assume role in each env Trust relationship of OrganizationRole
  * In each env: https://console.aws.amazon.com/iam/home?#/roles/OrganizationAccountAccessRole?section=trust
### Terraform
* In new environment:
  * [all] Allow api-gateway access to cloudwatch logs: `us-east-1/api-gateway`
  * [lower_env] Create subdomain zone: `global/dns`
* In NCP:
  * [lower_env] In NCP, add entry for new environment delegation: `global/dns/chownowapi-dot-com`
* In new environment:
  * [all] `us-east-1/services/channels-api`
  * [all] `us-east-1/services/facebook-business-integration/base`
  * [all] AWS Secrets Manager: Update secrets values with values from 1Password `Sentry DSN`, `DEV Facebook Integration` and `Datadog Ops API key` entries
  * [all] `us-east-1/services/facebook-business-integration/app`

### Cloudflare
  * [all] Add CNAME entry in chownowapi.com DNS:
    * channels.ENV.chownowapi.com => channels-origin.ENV.chownowapi.com
### Deploy and Test
* [Deploy lambda](https://jenkins.ops.svpn.chownow.com/job/Channels/job/Deploy%20Facebook%20Business%20Integration/build?delay=0sec)
  * Use a valid branch in the [channels-services](https://github.com/ChowNow/channels-services) repo
* Test:
  * https://channels.ENV.chownowapi.com/fbe/webhook?hub.mode=subscribe&hub.challenge=1188201444&hub.verify_token=KEbddKjmEXbiW.34AcqaQfmi



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name      | Description                         | Options |  Type  | Required? | Notes |
| :----------------- | :---------------------------------- | :------ | :----: | :-------: | :---- |
| name               | name                                |         | string |    No     |       |
| service            | name of service                     |         | string |    No     |       |
| api_gateway_name   | REST API gateway id                 |         | string |    Yes    |       |
| cors_allow_origins | comma separated list of origin URLs |         | string |    No     |       |
| domain_name        | DNS domain name                     |         | string |    Yes    |       |
| subdomain_name     | DNS subdomain name                  |         | string |    Yes    |       |
| env                | unique environment name             |         | string |    Yes    | N/A   |
| env_inst           | environment instance number         | 1...n   | string |    No     | N/A   |

#### Outputs

### Lessons Learned

* Destroying the datadog forwarder gets stuck because the bucket it uses is not empty, look for a bucket like this `s3://datadog-forwarder-facebook-integr-forwarderbucket-lq2i9ezuwoil` and delete the contents
