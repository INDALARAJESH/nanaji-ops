variable "public_key" {
  description = "public key to use for keypair"
}


variable "security_group_ids" {
  description = "security groups to assign to instance"
  default     = []
}

variable "instance_count" {
  description = "number of instances to provision"
  default     = 1
}

##################
# Disk Variables #
##################

variable "root_volume_type" {
  description = "The root volume type. Can be gp2 (ssd), gp3 (ssd), io1 (io provisioned), or standard (magnetic)."
  default     = "gp3" # https://aws.amazon.com/about-aws/whats-new/2020/12/introducing-new-amazon-ebs-general-purpose-volumes-gp3/
}

variable "root_volume_size" {
  description = "Size of the root volume, in gigabytes"
  default     = 100
}

variable "storage_delete_on_termination" {
  description = "Should this root block device be removed when terminating the instance?"
  default     = true
}
