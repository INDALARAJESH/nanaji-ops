module "dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = var.table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.name
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = var.extra_tags
}
