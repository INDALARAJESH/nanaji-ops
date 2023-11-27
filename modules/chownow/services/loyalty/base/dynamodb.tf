module "loyalty_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.table_name
  env                          = local.env
  hash_key                     = var.hashkey
  range_key                    = var.rangekey
  service                      = var.service
  autoscale_min_read_capacity  = var.read_capacity
  autoscale_min_write_capacity = var.write_capacity

  attribute_list = [
    {
      name = var.hashkey
      type = "S"
    },
    {
      name = var.rangekey
      type = "S"
    }
  ]
}
