variable "instance_size" {
  description = "Jumpbox Instance size"
  default     = "t3a.small"
}

variable "enable_teleport_event_handler" {
  description = "Enable teleport event handler"
  type        = bool
  default     = false
}
