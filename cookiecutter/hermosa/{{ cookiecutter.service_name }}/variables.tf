variable "service" {
  default = "{{ cookiecutter.service_name }}"
}

variable "alb_name_prefix" {
  default = "{{ cookiecutter.alb_name_prefix }}"
}

variable "cluster_name_prefix" {
  default = "{{ cookiecutter.cluster_name_prefix }}"
}

{% set hostnames = cookiecutter.alb_hostnames.split(',') %}
variable "alb_hostnames" {
  default = {{ hostnames | replace("'","\"") }}
}

variable "env" {
  description = "unique environment/stage name"
  default     = "{{ cookiecutter.environment }}"
}

variable "env_inst" {
  description = "unique environment instance name"
  default     = "{{ cookiecutter.environment_instance }}"
}

variable "aws_account_id" {
  default = "{{ cookiecutter.aws_account_id }}"
}

variable "aws_assume_role_name" {
  default = "OrganizationAccountAccessRole"
}

variable "web_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa-nginx"
}

variable "web_container_image_version" {
  default = "{{ cookiecutter.hermosa_web_image_tag }}"
}

variable "api_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa"
}

variable "api_container_image_version" {
  default = "{{ cookiecutter.hermosa_api_image_tag }}"
}

variable "task_ecr_repository_uri" {
  default = "449190145484.dkr.ecr.us-east-1.amazonaws.com/hermosa"
}

variable "task_container_image_version" {
  default = "{{ cookiecutter.hermosa_task_image_tag }}"
}

variable "ops_config_version" {
  description = "the version of ops repository used to generate the configuration"
  default     = "master"
}
