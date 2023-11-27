variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance name"
  default     = ""
}

variable "service" {
  description = "name of app/service"
  default     = "cloudfront"
}

locals {
  env = "${var.env}${var.env_inst}"

}
