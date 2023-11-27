variable "endpoint_policy" {
  description = "JSON policy to attach to the endpoint that controls access to the service"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "The service that you are connecting to (i.e. s3, ec2)"
  type        = string
}

variable "vpce_route_tables" {
  description = "List of route table ids to associate with the vpc endpoint"
  type        = list(string)
  default     = []
}

locals {
  endpoint_policy = var.endpoint_policy == "" ? data.aws_iam_policy_document.gateway_vpce.json : var.endpoint_policy

  # Terrible interpolation due to Terraform <0.12 not being able to validate list element type consistency
  # https://github.com/hashicorp/terraform/issues/12453
  route_table_ids = split(",", length(var.vpce_route_tables) > 0 ? join(",", var.vpce_route_tables) : join(",", data.aws_route_tables.all_route_tables.ids))
}
