module "search_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticsearch?ref=aws-elasticsearch-v2.0.2"

  domain_name                    = local.domain_name
  create_iam_service_linked_role = var.create_iam_service_linked_role
  allow_explicit_index           = true
  es_version                     = "OpenSearch_1.1"
  service                        = var.service
  env                            = var.env
  env_inst                       = var.env_inst
  ebs_enabled                    = true
  ebs_volume_size                = var.ebs_volume_size
  ebs_volume_type                = "gp2"
  zone_awareness_enabled         = true
  availability_zone_count        = 3

  # instance types and counts
  instance_type            = var.instance_type
  instance_count           = var.instance_count
  dedicated_master_type    = var.dedicated_master_type
  dedicated_master_count   = var.dedicated_master_count
  dedicated_master_enabled = var.dedicated_master_enabled

  vpc_options = {
    subnet_ids         = slice(tolist(data.aws_subnet_ids.selected.ids), 0, 3)
    security_group_ids = [module.ecs_sg.id]
  }
}

module "ecs_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  description = "security group to allow connections to opensearch"
  env         = var.env
  env_inst    = var.env_inst
  name_prefix = "elastic"
  service     = var.service
  vpc_id      = data.aws_vpc.private.id

  ingress_tcp_allowed = [443]
  cidr_blocks = [
    data.aws_vpc.private.cidr_block
  ]
}
