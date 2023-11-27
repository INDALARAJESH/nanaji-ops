module "dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  attribute_list               = var.attribute_list
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  billing_mode                 = var.billing_mode
  env                          = local.env
  global_secondary_index       = var.global_secondary_index
  hash_key                     = var.hash_key
  name                         = local.table_name
  service                      = var.name

  extra_tags = local.extra_tags
}
