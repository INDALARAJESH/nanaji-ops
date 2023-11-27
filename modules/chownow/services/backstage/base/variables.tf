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

variable "jenkins_api_key_secret_name" {
  description = "AWS Secret Manager {secret-name} to store Jenkins api key secret in /{env}/{service}/{secret-name} format"
  type        = string
  default     = "jenkins_api_key_secret"
}
