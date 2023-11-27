resource "aws_db_proxy" "this" {
  name                   = local.name
  debug_logging          = var.db_debug_logging
  engine_family          = upper(var.db_engine_family)
  idle_client_timeout    = var.db_idle_client_timeout
  require_tls            = var.db_require_tls
  role_arn               = aws_iam_role.db_proxy.arn
  vpc_security_group_ids = [aws_security_group.db_proxy.id]
  vpc_subnet_ids         = data.aws_subnet_ids.base.ids

  dynamic "auth" {
    for_each = var.secrets
    content {
      auth_scheme = var.auth_scheme
      iam_auth    = var.iam_auth
      secret_arn  = auth.value.arn
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name

  connection_pool_config {
    connection_borrow_timeout    = var.connection_borrow_timeout
    init_query                   = var.init_query
    max_connections_percent      = var.max_connections_percent
    max_idle_connections_percent = var.max_idle_connections_percent
    session_pinning_filters      = var.session_pinning_filters
  }
}

resource "aws_db_proxy_target" "db_instance" {
  count = var.target_db_instance ? 1 : 0

  db_proxy_name          = aws_db_proxy.this.name
  target_group_name      = aws_db_proxy_default_target_group.this.name
  db_instance_identifier = var.db_instance_identifier
}

resource "aws_db_proxy_target" "db_cluster" {
  count = var.target_db_cluster ? 1 : 0

  db_proxy_name         = aws_db_proxy.this.name
  target_group_name     = aws_db_proxy_default_target_group.this.name
  db_cluster_identifier = var.db_cluster_identifier
}

resource "aws_db_proxy_endpoint" "ro" {
  count                  = var.add_ro_rw_endpoints ? 1 : 0
  db_proxy_name          = aws_db_proxy.this.name
  db_proxy_endpoint_name = local.ro_name
  vpc_security_group_ids = [aws_security_group.db_proxy.id]
  vpc_subnet_ids         = data.aws_subnet_ids.base.ids
  target_role            = "READ_ONLY"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_db_proxy_endpoint" "rw" {
  count                  = var.add_ro_rw_endpoints ? 1 : 0
  db_proxy_name          = aws_db_proxy.this.name
  db_proxy_endpoint_name = local.rw_name
  vpc_security_group_ids = [aws_security_group.db_proxy.id]
  vpc_subnet_ids         = data.aws_subnet_ids.base.ids
  target_role            = "READ_WRITE"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}
