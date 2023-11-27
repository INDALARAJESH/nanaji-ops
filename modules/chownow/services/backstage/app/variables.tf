variable "service" {
  description = "the service name"
  type        = string
  default     = "backstage"
}

variable "env" {
  description = "the environment name"
  type        = string
  default     = "dev"
}

variable "vpc_name_prefix" {
  description = "Name of the vpc the service will on"
  type        = string
  default     = "main"
}

variable "domain_public" {
  description = "public domain name information used for R53 and ALB "
  type        = string
  default     = "svpn.chownow.com"
}

variable "wait_for_steady_state" {
  description = "wait for deployment to be ready"
  default     = true
}

variable "dns_ttl" {
  description = "TTL on route53 records"
  type        = string
  default     = 300
}

variable "container_port" {
  description = "Port the application runs on."
  type        = string
  default     = "7000"
}

variable "ecs_service_desired_count" {
  description = "desired number of task instances to run"
  default     = 1
}

variable "db_instance_identifier" {
  description = "Postgres Database ID used to retrieve the hostname to set the POSTGRES_HOST environment variable in ecs"
  type        = string
}
variable "db_password_secret_name" {
  description = "AWS Secret Manager {secret-name} to retrieve database password from in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "db_password"
}

variable "github_catalog_integration_secret_name" {
  description = "AWS Secret Manager {secret-name} to store github integration token used for catalog discovery in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "github_catalog_app"
}

variable "github_oauth_app_client_id_secret_name" {
  description = "AWS Secret Manager {secret-name} to store github oauth app client id used as an authentication provider in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "github_oauth_app_client_id"
}

variable "github_oauth_app_client_secret_name" {
  description = "AWS Secret Manager {secret-name} to store github oauth app client secret used as an authentication provider in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "github_oauth_app_client_secret"
}

variable "image_repo" {
  description = "Image repository URL used to define where to find the image to use in ecs"
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy"
  type        = string
}

## firelens vars

variable "firelens_container_name" {
  description = "firelens container name"
  default     = "log_router"
}

variable "firelens_container_ssm_parameter_name" {
  description = "firelens container ssm parameter name"
  default     = "/aws/service/aws-for-fluent-bit"
}

# stable version semver can be found here – https://github.com/aws/aws-for-fluent-bit/blob/mainline/AWS_FOR_FLUENT_BIT_STABLE_VERSION
variable "firelens_container_image_version" {
  description = "firelens container image version (tag)"
  default     = "2.25.1"
}

variable "firelens_options_dd_host" {
  description = "Host URI of the datadog log endpoint"
  default     = "http-intake.logs.datadoghq.com"
}

variable "dd_trace_enabled" {
  description = "Enable/disable datadog dd_trace"
  default     = true
}

variable "dd_agent_container_image_version" {
  description = "Datadog agent container image version (tag)"
  default     = "7"
}

variable "alb_access_logs_enabled" {
  description = "Enables ALB access logs, and will create an s3 bucket for storing them."
  type        = bool
  default     = false
}
