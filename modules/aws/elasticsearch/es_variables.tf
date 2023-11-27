variable "instance_type" {
  description = "The Amazon image size for pure-data nodes."
  default     = "t2.small.elasticsearch"
}

variable "instance_count" {
  default = 2
}

variable "domain_name" {
  default = ""
}

variable "color_suffix" {
  default = ""
}

variable "es_version" {
  description = "The version of ElasticSearch to use."
  default     = "5.5"
}

# EBS Options
variable "ebs_enabled" {
  description = "If true, use EBS for storage. Elasticsearch recommends against it."
  default     = false
}

variable "ebs_volume_size" {
  description = "The size of volume for each node"
  default     = 0
}

variable "ebs_volume_type" {
  description = "The disk storage type, gp2 is general purpose ssd"
  default     = ""
}

# Dedicated Master options
variable "dedicated_master_enabled" {
  default = false
}

variable "dedicated_master_type" {
  default = ""
}

variable "dedicated_master_count" {
  default = 0
}

variable "zone_awareness_enabled" {
  default = true
}

variable "proxy_ip" {
  default = ""
}

variable "allow_explicit_index" {
  description = "https://www.elastic.co/guide/en/elasticsearch/reference/1.5/url-access-control.html"
  default     = "false"
}

variable "availability_zone_count" {
  default = 2
}

variable "vpc_options" {
  type    = map(list(string))
  default = null
}

locals {
  domain_name  = var.domain_name != "" ? var.domain_name : "${var.service}-es-${local.env}${local.color_suffix}"
  color_suffix = var.color_suffix != "" ? "-${var.color_suffix}" : ""
}
