resource "aws_cloudwatch_event_bus" "main" {
  name = "${var.service}-${local.env}"
}

resource "aws_cloudwatch_event_bus_policy" "cross_account" {
  count          = length(var.cross_account_identifiers)
  policy         = data.aws_iam_policy_document.cross_account[count.index].json
  event_bus_name = "default"
}


resource "aws_cloudwatch_event_rule" "restaurant-search-backfill" {
  name        = "${var.service}-periodic-backfill-${local.env}"
  description = "Run ETL backfill for restaurant search service every ${var.rule_frequency} hours"

  schedule_expression = "rate(${var.rule_frequency} hour)"
}
