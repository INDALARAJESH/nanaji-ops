module "mul_2fa_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = "${var.mul_2fa_table_name}-${local.env}"
  service                      = var.service
  env                          = local.env
  attribute_list               = var.mul_2fa_attribute_list
  autoscale_min_write_capacity = var.mul_2fa_write_capacity
  autoscale_min_read_capacity  = var.mul_2fa_read_capacity
  billing_mode                 = var.mul_2fa_billing_mode
  hash_key                     = var.mul_2fa_hash_key
  enable_streams               = var.mul_2fa_enable_streams
  stream_view_type             = var.mul_2fa_stream_view_type

  extra_tags = local.extra_tags
}

resource "aws_dynamodb_table_item" "mul_2fa_items" {
  depends_on = [module.mul_2fa_dynamodb]
  table_name = "${var.mul_2fa_table_name}-${var.env}"
  hash_key   = var.mul_2fa_hash_key
  for_each   = var.mul_2fa_item_set
  item       = <<ITEM
{
  "phone_number": { "S": "${each.key}" },
  "account_address":  { "S":"${each.value.account_address}" },
  "to_address": { "S": "${each.value.to_address}"}
}
ITEM
}
