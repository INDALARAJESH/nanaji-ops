module "schedule_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.schedule_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}


module "menu_link_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.menu_link_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}


module "assets_upload_url_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.assets_upload_url_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}

module "salesforce_client_cache_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.salesforce_client_cache_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}

module "progress_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.progress_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}

module "website_access_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.website_access_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}

module "promotion_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.promotion_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}

module "onboarding_dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dynamodb?ref=aws-dynamodb-v2.0.1"

  name                         = local.onboarding_table_name
  env                          = local.env
  hash_key                     = var.hash_key
  service                      = var.service
  attribute_list               = var.attribute_list
  billing_mode                 = var.billing_mode
  autoscale_min_write_capacity = var.write_capacity
  autoscale_min_read_capacity  = var.read_capacity
  global_secondary_index       = var.global_secondary_index
  extra_tags                   = local.extra_tags
}
