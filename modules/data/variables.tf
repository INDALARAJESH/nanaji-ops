variable "env" {
  description = "environment id. must always exist, must be a member of local.envs, used to filter outputs for the caller.  possible valid values are: dev, qa, stg, uat, ncp"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "stg", "uat", "ncp"], var.env)
    error_message = "Invalid value for var.env."
  }
}

locals {
  xform = {
    "core_base" = data.terraform_remote_state.core_base_callers.outputs.this
  }

  env = var.env == "ncp" ? "prod" : var.env
}
