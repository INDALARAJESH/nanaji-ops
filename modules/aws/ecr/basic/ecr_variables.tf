variable "custom_name" {
  description = "custom name for ecr repo"
  default     = ""
}

variable "enable_container_scanning" {
  description = "boolean for enabling/disabling container scanning"
  default     = true
}

variable "enable_lifecycle_policy" {
  description = "boolean enabling for basic lifecycle policy"
  default     = 1
}

variable "custom_lifecycle_policy" {
  description = "rendered template of a lifecycle policy"
  default     = ""
}

#####################################
# SemVer Lifecycle Policy Variables #
#####################################
variable "semver_count" {
  description = "the amount of SemVer images to keep"
  default     = 30
}

variable "semver_prefix" {
  description = "the SemVer tag prefix(es) to associate with SemVer lifecycle policy"
  default     = "v"
}

variable "semver_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 10
}

######################################
# Feature Lifecycle Policy Variables #
######################################
variable "feature_count" {
  description = "the amount of feature images to keep"
  default     = 30
}

variable "feature_prefix" {
  description = "the feature tag prefix(es) to associate with feature lifecycle policy"
  default     = "cn-"
}

variable "feature_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 20
}

#####################################
# Base Lifecycle Policy Variables #
#####################################
variable "base_count" {
  description = "the amount of Base images to keep"
  default     = 10
}

variable "base_prefix" {
  description = "the Base tag prefix(es) to associate with Base lifecycle policy"
  default     = "base-"
}

variable "base_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 30
}

#####################################
# PR Lifecycle Policy Variables #
#####################################
variable "pr_count" {
  description = "the amount of PR images to keep"
  default     = 30
}

variable "pr_prefix" {
  description = "the PR tag prefix(es) to associate with PR lifecycle policy"
  default     = "pr-"
}

variable "pr_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 40
}

#############################################
# Develop Branch Lifecycle Policy Variables #
#############################################
variable "branch_develop_count" {
  description = "the amount of PR images to keep"
  default     = 15
}

variable "branch_develop_prefix" {
  description = "the PR tag prefix(es) to associate with PR lifecycle policy"
  default     = "develop-"
}

variable "branch_develop_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 50
}

#############################################
# Staging Branch Lifecycle Policy Variables #
#############################################
variable "branch_staging_count" {
  description = "the amount of PR images to keep"
  default     = 15
}

variable "branch_staging_prefix" {
  description = "the PR tag prefix(es) to associate with PR lifecycle policy"
  default     = "staging-"
}

variable "branch_staging_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 60
}

#######################################
# Untagged Lifecycle Policy Variables #
#######################################
variable "untagged_count" {
  description = "the amount of untagged images to keep"
  default     = 5
}

variable "untagged_rule_priority" {
  description = "the ECR lifecycle rule priority"
  default     = 100
}

###################################
# ECR Repository Policy Variables #
###################################

variable "repository_policy" {
  description = "JSON-formatted ecr repository policy"
  default     = ""
}

variable "enable_lower_env_ro" {
  description = "enables/disables lower environments from reading from this ECR repo"
  default     = 1
}
