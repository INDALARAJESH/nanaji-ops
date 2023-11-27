variable "env" {
  description = "unique environment/stage name"
  default     = "dev"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "menu"
}

variable "service_id" {
  description = "unique service identifier, eg '-in' => integrations-in"
  default     = ""
}

variable "vpc_name_prefix" {
  description = "prefix added to var.env to select which vpc the service will on"
  type        = string
  default     = "nc"
}

variable "custom_vpc_name" {
  description = "option to override destination vpc"
  default     = ""
}

variable "domain" {
  description = "domain name information, e.g. chownow.com"
  default     = "chownow.com"
}

variable "db_instance_class" {
  description = "database instance size"
  default     = "db.t2.small"
}

variable "max_connections" {
  # NOTE:
  # If we change the instance size of the DB we will need to the max_connection value as well
  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Managing.Performance.html
  description = "max number of DB connections, used only for non-prod envs"
}

locals {
  env                = "${var.env}${var.env_inst}"
  container_web_name = "${var.service}-web-${local.env}"
  dns_zone           = "${local.env}.svpn.${var.domain}"
  service            = "${var.service}${var.service_id}"
  vpc_name           = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    Service             = var.service
    ServiceFamily       = "MenuService"
    TFModule            = "modules/chownow/services/menu/db"
  }
}
