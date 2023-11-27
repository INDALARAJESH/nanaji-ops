# AWS Backup

### General

* Description: This code is to create a backup of an EBS volume
* Created By: Allen Dantes
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`, `template`
* Terraform Version: 0.14.x

![aws-backup](https://github.com/ChowNow/ops-tf-modules/workflows/aws-backup/badge.svg)

### Usage

* Terraform:

```hcl
module "backup" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/backup?ref=aws-backup-v2.0.0"
  service        = var.service
  env            = var.env
  schedule       = var.schedule
  lifecycle_days = var.lifecycle_days
  volume_id      = aws_ebs_volume.ebs_volume.*.arn
}

data "aws_iam_policy_document" "backup-addtl" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:CreateBackup",
      "dynamodb:DescribeBackup",
      "dynamodb:DeleteBackup"
    ]

    resources = [
      "arn:aws:dynamodb:${local.region}:${local.aws_account_id}:table/${var.service}-dynamodb-${env}/*",
      "arn:aws:dynamodb:${local.region}:${local.aws_account_id}:table/${var.service}-dynamodb-${env}"
    ]
  }
}

```

### Options

* Description: Input variable options and Outputs for other modules to consume


#### Inputs

| Variable Name              | Description                            | Options                         | Type     | Required? | Notes |
| :------------------------- | :------------------------------------- | :------------------------------ | :------: | :-------: | :---- |
| env                        | unique environment/stage name          | sandbox/dev/qa/uat/stg/prod/etc | string   |  Yes      | N/A   |
| service                    | name of service                        | default: app                    | string   |  Yes      | N/A   |
| schedule                   | Cron Schedule                          | example: cron(0 12 * * ? *)     | string   |  Yes      | N/A   |
| lifecycle_days             | Lifecycle Days                         | default: 30                     | string   |  No       | N/A   |
| backup_arn                 | Resource AR                            |                                 | list     |  Yes      | N/A   |
| aux_iam_policy             | auxiliary rendered iam policy          |                                 | string   |  Yes      | N/A   |


#### Outputs

| Variable Name         | Description                                                       | Type    | Notes |
| :-------------------- | :---------------------------------------------------------------- | :-----: | :---- |
| app_iam_role           | app IAM role                                                     | string  |       |

### Lessons Learned

* Getting the ARN for a volume can be tricky, if you know the volume ID, you can use the format:

`["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:volume/${var.volume_id}"]`


### References
