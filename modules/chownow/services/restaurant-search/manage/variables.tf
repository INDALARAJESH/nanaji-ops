variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "api_source_code_version" {
  description = "commit sha of the source code that will be deployed"
}

variable "vpc_name" {
  description = "The name of the VPC that this infrastructure will be created in"
}

variable "docker_image_uri" {
  description = "URI of docker image"
}

variable "service" {
  description = "name of the service"
  default     = "restaurant-search"
}

variable "replica_db_name" {
  description = "name of the service"
  default     = "hermosa"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "https://55ea1d34f16748dda3331c400c603234@o32006.ingest.sentry.io/6237961"
}

variable "es_domain_name_suffix" {
  description = "Suffix for the OpenSearch domain name (i.e. uat00)"
  default     = ""
}

locals {
  env                   = "${var.env}${var.env_inst}"
  container_name        = "${var.service}-manage-${local.env}"
  service_role          = "manage"
  es_domain_name_suffix = var.es_domain_name_suffix != "" ? var.es_domain_name_suffix : local.env
}
