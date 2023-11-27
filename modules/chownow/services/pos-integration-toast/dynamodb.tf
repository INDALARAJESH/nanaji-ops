locals {
  db_table_name         = "PosToast-${local.env}"
  db_partition_key      = "PartitionKey"
  db_sort_key           = "SortKey"
  db_cn_restaurant_id   = "restaurant_id"
  db_item_ttl_attribute = "expires_at"

  # "GSI_1" is currently the default in the toast service code
  db_cn_restaurant_gsi_name = "CNRestaurantIdIndex"

  db_attribute_list = [
    {
      name = local.db_partition_key
      type = "S"
    },
    {
      name = local.db_sort_key
      type = "S"
    },
    {
      name = local.db_cn_restaurant_id
      type = "S"
    }
  ]
}

resource "aws_dynamodb_table" "toast" {
  name         = local.db_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.db_partition_key
  range_key    = local.db_sort_key

  stream_enabled   = var.enable_dynamo_stream
  stream_view_type = var.enable_dynamo_stream ? "NEW_AND_OLD_IMAGES" : null

  dynamic "attribute" {
    for_each = local.db_attribute_list

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    enabled        = true
    attribute_name = local.db_item_ttl_attribute
  }

  point_in_time_recovery {
    enabled = var.enable_dynamo_pitr
  }

  global_secondary_index {
    name            = local.db_cn_restaurant_gsi_name
    hash_key        = local.db_cn_restaurant_id
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled = true
  }
}
