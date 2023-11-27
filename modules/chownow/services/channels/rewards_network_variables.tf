variable "enable_rewards_network" {
  description = "boolean toggle to create rewards_network resources"
  default     = true
}

variable "rewards_network_s3_principals" {
  description = "IAM principals allowed to access rewards network S3 bucket"
  default = [
    "arn:aws:iam::200180887877:root",
    "arn:aws:iam::873396552790:root"
  ]
  type = list(string)
}
