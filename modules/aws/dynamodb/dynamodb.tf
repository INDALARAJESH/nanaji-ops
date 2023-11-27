resource "aws_dynamodb_table" "provision" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled != true ? 1 : 0

  name             = var.name
  billing_mode     = var.billing_mode
  read_capacity    = var.autoscale_min_read_capacity
  write_capacity   = var.autoscale_min_write_capacity
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.enable_streams
  stream_view_type = var.stream_view_type

  dynamic "attribute" {
    for_each = var.attribute_list

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled = var.enable_encryption
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  ttl {
    attribute_name = var.ttl_name
    enabled        = var.ttl_name == "" ? false : true
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = global_secondary_index.value.write_capacity
      read_capacity      = global_secondary_index.value.read_capacity
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_dynamodb_table" "on-demand" {
  count = var.billing_mode == "PAY_PER_REQUEST" ? 1 : 0

  name             = var.name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.enable_streams
  stream_view_type = var.stream_view_type

  dynamic "attribute" {
    for_each = var.attribute_list

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled = var.enable_encryption
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  ttl {
    attribute_name = var.ttl_name
    enabled        = var.ttl_name == "" ? false : true
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = global_secondary_index.value.write_capacity
      read_capacity      = global_secondary_index.value.read_capacity
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_dynamodb_table" "provision_with_auto_scaling" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled == true ? 1 : 0

  name             = var.name
  billing_mode     = var.billing_mode
  read_capacity    = var.autoscale_min_read_capacity
  write_capacity   = var.autoscale_min_write_capacity
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = var.enable_streams
  stream_view_type = var.stream_view_type

  dynamic "attribute" {
    for_each = var.attribute_list

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled = var.enable_encryption
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  ttl {
    attribute_name = var.ttl_name
    enabled        = var.ttl_name == "" ? false : true
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = global_secondary_index.value.write_capacity
      read_capacity      = global_secondary_index.value.read_capacity
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )

  lifecycle {
    ignore_changes = [write_capacity, read_capacity]
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled == true ? 1 : 0

  max_capacity       = var.autoscale_max_read_capacity
  min_capacity       = var.autoscale_min_read_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled == true ? 1 : 0

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.autoscale_read_target_value
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled == true ? 1 : 0

  max_capacity       = var.autoscale_max_write_capacity
  min_capacity       = var.autoscale_min_write_capacity
  resource_id        = "table/${var.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count = var.billing_mode == "PROVISIONED" && var.autoscaling_enabled == true ? 1 : 0

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.autoscale_write_target_value
  }
}
