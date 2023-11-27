variable "instance_type" {
  description = "The Amazon image size for pure-data nodes."
  default     = "t2.small.elasticsearch"
}

variable "instance_count" {
  default = 4
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
  default     = true
}

variable "ebs_volume_size" {
  description = "The size of volume for each node"
  default     = 20
}

variable "ebs_volume_type" {
  description = "The disk storage type, gp2 is general purpose ssd"
  default     = "gp2"
}

# Dedicated Master options
variable "dedicated_master_enabled" {
  default = true
}

variable "dedicated_master_type" {
  default = "t2.small.elasticsearch"
}

variable "dedicated_master_count" {
  default = 3
}

# Elasticsearch Cluster Options

variable "allow_explicit_index" {
  default = true
}
