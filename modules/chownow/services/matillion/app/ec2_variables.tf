variable "ingress_tcp_allowed" {
  description = "inbound TCP ports for matillion"
  default     = ["22", "80", "443"]
}

variable "instance_type" {
  description = "ec2 instance size"
  default     = "m4.large"
}

variable "root_volume_size" {
  description = "root value size"
  default     = 1000
}

variable "tg_port" {
  description = "target group TCP port"
  default     = 80
}

variable "custom_ami" {
  description = "bypasses data source lookup to provide custom AMI"
  default     = ""
}
