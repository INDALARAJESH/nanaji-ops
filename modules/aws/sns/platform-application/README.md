# SNS Platform Application

### General

* Description: A generic module to provision a SNS Platform Application.
* Created By: Jobin Muthalaly
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: ~> 1.5.0

![aws-sns-platform-app](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sns-platform-app/badge.svg)

### Usage


```
module "ios_marketplace_live_activity" {
  source                   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/platform-application?ref=aws-sns-platform-app-v3.0.0"
  app_name                 = var.platform_app_name
  env                      = local.env
  platform                 = local.platform
  platform_credential      = local.apns_signing_key
  platform_principal       = local.apns_signing_key_id
  apple_platform_team_id   = var.apple_team_id
  apple_platform_bundle_id = var.apple_bundle_id
}
```

The name of the SNS Platform Application is generated as `${var.service}-${var.env}`, so in the example above, it would be `iOSMarketplaceLiveActivity-dev` when `env='dev'`

#### Inputs

| Variable Name               | Description                  | Options                     | Type   | Required? | Notes |
| :-------------------------- | :--------------------------- | :-------------------------- | :----: | :-------: | :---- |
| `env`                       | environment                  | qa, stg, etc                | string |  Yes      | N/A   |
| `env_inst`                  | environment instance         | 00, 01, etc                 | string |  No       | N/A   |
| `service`                   | name of SNS PA service       | Used to name the PA         | string |  Yes      | N/A   |
| `platform`                  | specify an app platform      | APNS, APNS_SANDBOX, GCM     | string |  Yes      | N/A   |
| `platform_credential`       | cert key/api key [1]         |                             | string |  Yes      | N/A   |
| `platform_principal`        | cert/empty [2]               |                             | string |  No       | N/A   |
| `apple_platform_team_id`    | for token based APNS         |                             | string |  No       | N/A   |
| `apple_platform_bundle_id`  | for token based APNS         |                             | string |  No       | N/A   |


* [1] platform_credential is the certificate key for APNS; it is the Firebase API key for GCM
* [2] platform_principal is an Apple issued cert for APNS; it is not used for GCM platform



#### Outputs

| Variable Name     | Description                  | Type   | Notes |
| :---------------- | :--------------------------- | :----: | :---- |
| `id`              | SNS Platform App ID          | string | N/A   |
| `arn`             | SNS Platform App ARN         | string | N/A   |
