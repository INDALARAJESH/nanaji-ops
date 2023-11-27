variable "service" {
  description = "unique service name for project/application"
  default     = ""
}

variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "domain" {
  description = "domain name information"
  default     = "chownow.com"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "extra_tags" {
  description = "optional addition for tags"
  default     = {}
}

variable "custom_vpc_name" {
  description = "vpc override for resource placement"
  default     = ""
}

variable "custom_name" {
  description = "customize unique name of the redis cluster. Defaults to <service>-redis-<env><env_inst>"
  default     = ""
}

variable "additional_security_groups" {
  description = "additional security groups to attach to the cluster"
  default     = []
}

variable "availability_zones" {
  description = "override availability zones used for the cache instances"
  default     = []
}

variable "private_dns_zone" {
  description = "allow to fetch private or public dns zone"
  default     = true
}

variable "dns_zone" {
  description = "use specific dns zone"
  default     = ""
}

locals {
  availability_zones      = length(var.availability_zones) != 0 ? var.availability_zones : data.aws_availability_zones.available.names
  azs                     = slice(local.availability_zones, 0, var.ec_rg_number_cache_clusters)
  dns_zone                = var.dns_zone == "" ? "${local.env}.aws.${var.domain}" : var.dns_zone
  domain                  = var.dns_zone == "" ? "${local.env}.aws.${var.domain}" : "${local.env}.aws.${var.dns_zone}"
  ec_parameter_group_name = var.custom_parameter_group_name != "" ? var.custom_parameter_group_name : aws_elasticache_parameter_group.ec[0].name
  env                     = "${var.env}${var.env_inst}"
  name                    = var.custom_name != "" ? var.custom_name : "${var.service}-redis-${local.env}"
  vpc_name                = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"
  cname_endpoint          = var.custom_cname_endpoint != "" ? var.custom_cname_endpoint : "${var.service}-redis"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    VPC                 = local.vpc_name
    Service             = var.service
  }
}
