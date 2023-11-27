# Python3 Lambda publish-from-sns

### General

* Description: Creates publish-from-sns Lambda function(s) and all associated resources
* Created By: Tim Ho
* Module Dependencies: `chownow/aws/account/region/base`
* Provider Dependencies: `aws`

![cn-services-lambda-publish-from-sns](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-lambda-publish-from-sns/badge.svg)

### Usage

* Terraform:

```hcl
module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/publish-from-sns?ref=cn-lambda-publish-from-sns-v2.0.0"

  env           = var.env
  lambda_layers = local.lambda_layers
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                     | Description                   | Options             |  Type  | Required? | Notes |
| :-------------------------------- | :---------------------------- | :------------------ | :----: | :-------: | :---- |
| env                               | unique environment/stage name | dev/qa/prod/stg/uat | string |    Yes    | N/A   |
| env_inst                          | iteration of environment      | eg 00,01,02,etc     | string |    No     | N/A   |
| slack_lambda_layers               | list of lambda layer names    | valid lambda layers |  list  |    No     | N/A   |
| slack_lambda_name                 | slack lambda name             |                     | string |    No     | N/A   |
| slack_lambda_description          | slack lambda description      |                     | string |    No     | N/A   |
| slack_lambda_handler              | slack lambda handler          | valid handler       | string |    No     | N/A   |
| slack_lambda_env_slack_channel    | SLACK_CHANNEL env var         |                     | string |    No     | N/A   |
| slack_lambda_env_slack_icon_emoji | SLACK_ICON_EMOJI env var      |                     | string |    No     | N/A   |
| slack_lambda_env_slack_username   | SLACK_USERNAME env var        |                     | string |    No     | N/A   |
| slack_webhook_secret_path         | secretsmanager path           | valid path          | string |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |

### Considerations
- This Terraform module is meant to house one or many Lambda functions (all functions under `ops-serverless/publish-from-sns`), and their associated resources. At the time of writing, the only Lambda in `ops-serverless/publish-from-sns` is the `sns_to_slack` function, but there may be a need to create separate endpoints in the future (e.g. Salesforce, AWS Chime, etc). Distinct modules can be built out per new function, though it seems easier to match one-to-one between ops-tf-modules and ops-serverless.
- `var.slack_lambda_handler` defaults to `slack.lambda_handler` so that this Terraform module can utilize the same ops-serverless folder (ops-serverless/publish-from-sns) per new lambda function. For example, if a `sns_to_salesforce` lambda function is created, a new Python module can be created within the same ops-serverless folder (i.e. ops-serverless/publish-from-sns/salesforce.py). The lambda handler for this new function could be `salesforce.lambda_handler`.

E.g. ops-serverless/publish-from-sns
```
publish-from-sns
├── Makefile
└── src
    ├── endpoint.py
    ├── salesforce.py
    └── slack.py
```
