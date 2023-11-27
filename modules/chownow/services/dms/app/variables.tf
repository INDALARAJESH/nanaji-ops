variable "service" {
  description = "name of app/service"
  default     = "dms"
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

variable "vpc_name_prefix" {
  description = "vpc name prefix to use as a location of where to pull data source information and to build resources"
  default     = "nc"
}

variable "web_ecs_config" {
  description = <<_EOT
    static configuration for the "web container" ecs service from the caller state.
      desired: [int] number of web containers that should be running
  _EOT
  type = object({
    desired = number
  })
}

variable "s3_bucket_base_name" {
  description = "name of the s3 bucket without the environment appended"
  default     = "cn-mds-files"
}

variable "containers_env_config" {
  description = <<_EOT
      static configuration for adjusting task container env from the caller state.
        sendgrid_delighted_enabled: [bool] passes this value directly to the container environment. used for sending delighted emails from sendgrid.
  _EOT
  type = object({
    sendgrid_delighted_enabled = bool
  })
}

locals {
  env            = "${var.env}${var.env_inst}"
  container_name = "${var.service}-web-${local.env}"
  tg_name        = "${var.service}-pub-${local.env}-${var.container_port}"
  dns_zone       = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  s3_bucket_name = "${var.s3_bucket_base_name}-${local.env}"
}
