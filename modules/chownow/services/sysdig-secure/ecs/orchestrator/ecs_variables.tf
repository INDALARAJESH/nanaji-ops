### SERVICE VARIABLES ###
variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION"
  default     = "SERVICE"
}

variable "assign_public_ip" {
  description = "Provisions a public IP for the service. Required when using an Internet Gateway for egress."
  type        = bool
  default     = false
}

variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}


### TASK VARIABLES ###
variable "task_cpu" {
  description = "minimum cpu required for the task to be scheduled"
  default     = 2048
}

variable "task_memory" {
  description = "minimum memory required for the task to be scheduled"
  default     = 8192
}

variable "collector_host" {
  description = "Sysdig Collector host URL based on account region"
  default     = "ingest.us4.sysdig.com"
}

variable "agent_image" {
  description = "Orchestrator agent image"
  type        = string
  default     = "quay.io/sysdig/orchestrator-agent:latest"
}

variable "orchestrator_port" {
  description = "Port for the workload agent to connect"
  type        = number
  default     = 6667
}

variable "collector_port" {
  description = "Sysdig collector port"
  type        = string
  default     = "6443"
}


### OPTIONAL VARIABLES ###
variable "agent_tags" {
  description = "Comma separated list of tags for this agent"
  type        = string
  default     = ""
}

variable "check_collector_certificate" {
  description = "Whether to check the collector certificate when connecting. Mainly for development."
  type        = string
  default     = "true"
}

variable "collector_ca_certificate" {
  description = "Uploads the collector custom CA certificate to the orchestrator"
  type = object({
    type  = string
    value = string
    path  = string
  })
  default = ({
    type  = "base64"
    value = ""
    path  = "/ssl/collector_cert.pem"
  })
}

variable "collector_configuration" {
  description = "Advanced configuration options for the connection to the collector"
  type = object({
    ca_certificate = string
  })
  default = ({
    ca_certificate = "" # /ssl/collector_cert.pem
  })
}

variable "http_proxy_ca_certificate" {
  description = "Uploads the HTTP proxy CA certificate to the orchestrator"
  type = object({
    type  = string
    value = string
    path  = string
  })
  default = ({
    type  = "base64"
    value = ""
    path  = "/ssl/proxy_cert.pem"
  })
}

variable "http_proxy_configuration" {
  description = "Advanced configuration options for the connection to the HTTP proxy"
  type = object({
    proxy_host             = string
    proxy_port             = string
    proxy_user             = string
    proxy_password         = string
    ssl                    = string
    ssl_verify_certificate = string
    ca_certificate         = string
  })
  default = ({
    proxy_host             = ""
    proxy_port             = ""
    proxy_user             = ""
    proxy_password         = ""
    ssl                    = ""
    ssl_verify_certificate = ""
    ca_certificate         = "" # /ssl/proxy_cert.pem
  })
}


locals {
  ecs_cluster_name   = "sysdig-secure-${var.vpc_name}"
  ecs_service_name   = "sysdig-orchest-${var.vpc_name}"
  container_name     = "orchestrator-agent"
  container_hostname = "fargate-orchestrator-agent-${var.vpc_name}"


  do_upload_ca_certificate_collector = var.collector_ca_certificate.value != "" ? true : false
  do_configure_connection_collector  = var.collector_configuration.ca_certificate != "" ? true : false

  do_upload_ca_certificate_http_proxy = var.http_proxy_ca_certificate.value != "" ? true : false
  do_configure_connection_http_proxy  = var.http_proxy_configuration.proxy_host != "" ? true : false

}
