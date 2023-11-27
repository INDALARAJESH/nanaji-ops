variable "layer_function_language" {
  description = "layer function language (i.e. python3)"
  default     = "python3"
}

variable "layer_compatible_runtimes" {
  type        = list(string)
  description = "list of layer compatible runtimes"
  default     = ["python3.7", "python3.8"]
}

variable "layer_description" {
  description = "lambda layer description"
}

variable "layer_name" {
  description = "lambda layer name"
}

locals {
  layer_classification       = "${var.layer_function_language}_${var.layer_name}_${local.env}_${replace(data.aws_region.current.name, "-", "")}"
  layer_classification_lower = lower(local.layer_classification)
}
