variable "function_runtime" {
  description = "cloudfront runtime"
  default     = "cloudfront-js-1.0"
}

variable "function_publish" {
  description = "Publish Cloudfront Function"
  default     = true
}

variable "file_path" {
  description = "path for javascript file"
}

variable "function_name" {
  description = "name of function"
}
