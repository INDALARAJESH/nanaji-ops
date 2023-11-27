variable "vpc_subnet_tag_value" {
  description = "Used to filter down available subnets"
  default     = "private_base"
}

variable "vpc_subnet_list" {
  description = "Used to filter down available subnets"
  default     = []
}

locals {
  vpc_subnet_cidrs = [for s in data.aws_subnet.subnet : s.cidr_block]
  vpc_azs          = [for s in data.aws_subnet.subnet : s.availability_zone]

}
