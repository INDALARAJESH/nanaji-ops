module "sherlock_backup" {
  source         = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/backup?ref=backup-v1.0.2"
  aux_iam_policy = "${data.aws_iam_policy_document.backup-addtl.json}"
  service        = "${var.service}"
  env            = "${var.env}"
  schedule       = "${var.backup_schedule}"
  lifecycle_days = "${var.lifecycle_days}"
  backup_arn     = "${data.aws_dynamodb_table.table_name.arn}"
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
      "arn:aws:dynamodb:${local.region}:${local.aws_account_id}:table/${var.service}-dynamodb-${local.env}/*",
      "arn:aws:dynamodb:${local.region}:${local.aws_account_id}:table/${var.service}-dynamodb-${local.env}"
    ]
  }
}
