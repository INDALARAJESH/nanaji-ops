resource "aws_elasticache_parameter_group" "ec" {
  count = var.enable_parameter_group == 1 ? 1 : 0

  name   = local.name
  family = var.elasticache_param_family

  # no parameters yet, this is just a stub for now
}

resource "aws_elasticache_subnet_group" "ec" {
  name       = local.name
  subnet_ids = data.aws_subnet_ids.private_base.ids
}

resource "aws_elasticache_replication_group" "ec" {
  automatic_failover_enabled    = var.ec_rg_automatic_failover_enabled
  at_rest_encryption_enabled    = var.ec_at_rest_encryption_enabled
  availability_zones            = local.azs
  engine_version                = var.ec_rg_engine_version
  node_type                     = var.ec_rg_node_type
  number_cache_clusters         = var.ec_rg_number_cache_clusters
  parameter_group_name          = local.ec_parameter_group_name
  port                          = var.redis_tcp_port
  replication_group_description = "${local.name} redis replication group"
  replication_group_id          = local.name
  security_group_ids            = concat(var.additional_security_groups, [aws_security_group.redis.id])
  subnet_group_name             = aws_elasticache_subnet_group.ec.name
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = local.redis_authtoken
  multi_az_enabled              = var.multi_az_enabled && length(local.azs) > 1
  snapshot_name                 = var.snapshot_name
  snapshot_retention_limit      = var.snapshot_retention_limit
  snapshot_window               = var.snapshot_window

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )
}

######################
# DNS CNAME Creation #
######################
resource "aws_route53_record" "private_record_db_redis" {
  zone_id = var.private_dns_zone ? data.aws_route53_zone.private[0].zone_id : data.aws_route53_zone.public[0].zone_id
  name    = "${local.cname_endpoint}.${local.dns_zone}." # eg. dms-redis.qa.aws.chownow.com.
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_elasticache_replication_group.ec.primary_endpoint_address}."]

  lifecycle {
    ignore_changes = [records] # This will be updated out-of-band via API during DB refreshes
  }
}

resource "aws_route53_record" "private_record_db_redis_reader" {
  count = var.enable_record_redis_reader == 1 ? 1 : 0

  zone_id = var.private_dns_zone ? data.aws_route53_zone.private[0].zone_id : data.aws_route53_zone.public[0].zone_id
  name    = "${local.cname_endpoint}-reader.${local.dns_zone}." # eg. dms-redis-reader.qa.aws.chownow.com.
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_elasticache_replication_group.ec.reader_endpoint_address}."]

  lifecycle {
    ignore_changes = [records] # This will be updated out-of-band via API during DB refreshes
  }
}
