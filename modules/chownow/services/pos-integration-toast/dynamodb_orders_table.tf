locals {
  db_orders_table_name          = "PosToastOrders-${local.env}"
  db_orders_table_partition_key = "OrderID"

  db_orders_table_attribute_list = [
    {
      name = local.db_orders_table_partition_key
      type = "S"
    },
  ]
}

resource "aws_dynamodb_table" "toast_orders" {
  name         = local.db_orders_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.db_orders_table_partition_key

  stream_enabled   = var.enable_dynamo_stream
  stream_view_type = var.enable_dynamo_stream ? "NEW_AND_OLD_IMAGES" : null

  dynamic "attribute" {
    for_each = local.db_orders_table_attribute_list

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = var.enable_dynamo_pitr
  }

  server_side_encryption {
    enabled = true
  }
}
