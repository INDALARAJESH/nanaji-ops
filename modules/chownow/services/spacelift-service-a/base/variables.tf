variable "env" {
  description = "unique/short environment name"
}


locals {
  bucket_name = "cn-spacelift-test-${var.env}"
}
