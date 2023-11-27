variable "cloudflare_zone_id" {
  description = "The zone identifier to target for the resource"
}

variable "cloudflare_name" {
  description = "Cloudflare Rule Name"
}

variable "cloudflare_description" {
  description = "Brief summary of the ruleset and its intended use"
}

variable "cloudflare_kind" {
  description = "Type of Ruleset to create"
}

variable "cloudflare_phase" {
  description = "Point in the request/response lifecycle where the ruleset will be created"
}

variable "rules" {
  description = "Point in the request/response lifecycle where the ruleset will be created"
  default     = []
}
