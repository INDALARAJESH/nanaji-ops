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

variable "td_cpu" {
  description = "allocated vCPU - example: 1024 or '1 vCPU' or '1 vcpu'"
  default     = 1024
}

variable "td_memory" {
  description = "allocated memory - example: 2048 or '2GB' or '2 GB' "
  default     = 2048
}

variable "desired_count" {
  description = "number of application containers to start"
  default     = 2
}

variable "service" {
  description = "name of the service"
  default     = "restaurant-search"
}

variable "sentry_dsn" {
  description = "Sentry.io API key"
  default     = "https://55ea1d34f16748dda3331c400c603234@o32006.ingest.sentry.io/6237961"
}

variable "es_domain_name_suffix" {
  description = "Suffix for the OpenSearch domain name (i.e. uat00)"
  default     = ""
}

variable "api_wsgi_workers" {
  description = "The number of workers the wsgi should start for the API."
  default     = "1"
}

locals {
  env                   = "${var.env}${var.env_inst}"
  container_name        = "${var.service}-${local.env}"
  container_port        = 8080
  service_role          = "api"
  es_domain_name_suffix = var.es_domain_name_suffix != "" ? var.es_domain_name_suffix : local.env
}
