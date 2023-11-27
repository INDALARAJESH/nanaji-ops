variable "schedule" {
  description = "Cron Schedule" #cron(0 12 * * ? *)
}

variable "lifecycle_days" {
  description = "How long you want to keep each backup in days"
  default     = "30"
}

variable "backup_arn" {
  description = "arn for resource you are trying to back up"
  type        = list(string)
}

variable "aux_iam_policy" {
  description = "auxiliary rendered codebuild iam policy"
  default     = ""
}
