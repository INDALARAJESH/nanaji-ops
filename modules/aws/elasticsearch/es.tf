resource "aws_elasticsearch_domain" "es" {
  domain_name           = local.domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_type
    dedicated_master_count   = var.dedicated_master_count

    # Zone awareness requires that we use an even number of instances.
    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.domain_name }
  )

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    cloudwatch_log_group_arn = module.index_log_group[0].arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    cloudwatch_log_group_arn = module.search_log_group[0].arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    cloudwatch_log_group_arn = module.application_log_group[0].arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  advanced_options = {
    # Closes a potential security hole.
    # https://www.elastic.co/guide/en/elasticsearch/reference/1.5/url-access-control.html
    "rest.action.multi.allow_explicit_index" = var.allow_explicit_index
  }

  dynamic "vpc_options" {
    for_each = toset(var.vpc_options != null ? [""] : [])

    content {
      subnet_ids         = lookup(var.vpc_options, "subnet_ids")
      security_group_ids = lookup(var.vpc_options, "security_group_ids")
    }
  }
  # the above dynamic block will generate the following data structure when vpc_options are set
  # vpc_options {
  #   subnet_ids = [...]
  #   security_group_ids = [...]
  # }

  access_policies = data.aws_iam_policy_document.es_policy.json
}
