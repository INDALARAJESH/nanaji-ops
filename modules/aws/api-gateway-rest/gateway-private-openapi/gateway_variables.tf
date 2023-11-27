variable "openapi_spec_json" {
  description = "JSON-encoded OpenAPI spec with x-amazon-apigateway-integration extensions"
  type        = string
}

variable "source_vpc_endpoint_ids" {
  description = "Set of VPC Endpoint identifiers. Used by private API GWs resource policy / filter to explicitly allow traffic from"
  type        = list(string)
}

variable "vpc_endpoint_ids" {
  description = "Set of VPC Endpoint identifiers. Used by private API GWs to be reachable at"
  type        = list(string)
}
