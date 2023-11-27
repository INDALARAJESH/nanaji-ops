module "es" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticsearch?ref=aws-elasticsearch-v2.0.2"
  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  instance_type            = var.instance_type
  instance_count           = var.instance_count
  dedicated_master_enabled = var.dedicated_master_enabled
  dedicated_master_type    = var.dedicated_master_type
  dedicated_master_count   = var.dedicated_master_count
  allow_explicit_index     = var.allow_explicit_index

  ebs_enabled     = var.ebs_enabled
  ebs_volume_size = var.ebs_volume_size
  ebs_volume_type = var.ebs_volume_type

  vpc_options = local.vpc_options
}
