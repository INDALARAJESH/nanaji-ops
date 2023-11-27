variable "schedule" {
  default = "cron(1 */2 ? * * *)"
}

variable "launch_type" {
  default = "FARGATE"
}

variable "platform_version" {
  default = "1.4.0"
}

variable "program" {
  default = "node"
}

variable "path" {
  default = "scripts/run_scan.js"
}
