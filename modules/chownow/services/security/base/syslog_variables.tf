# not recommended to enable because this will place a keys in the terraform statefile,
# this is only an option to support legacy deployments
variable "create_syslog_access_key" {
  description = "creates access key for IAM user"
  default     = 0
}
