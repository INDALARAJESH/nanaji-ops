variable "enable_vpce_datadog" {
  description = "enable creation of DataDog VPC Endpoints"
  default     = 0
}

variable "enable_vpce_aws" {
  description = "enable creation of common AWS Service VPC Endpoints"
  default     = 0
}


locals {
  dd_service_endpoints = {
    logs_http_agent = {
      name         = "dd-logs-http-agent-${var.vpc_name}"
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-025a56b9187ac1f63"
    }
    logs_http_user = {
      name         = "dd-logs-http-user-${var.vpc_name}"
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0e36256cb6172439d"
    }
    api = {
      name         = "dd-api-${var.vpc_name}"
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-064ea718f8d0ead77"
    }
    metrics = {
      name         = "dd-metrics-${var.vpc_name}"
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-09a8006e245d1e7b8"
    }
    traces = {
      name         = "dd-traces-${var.vpc_name}"
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0355bb1880dfa09c2"
    }
    # containers = {
    #   name         = "dd-containers-${var.vpc_name}"
    #   service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0ad5fb9e71f85fe99"
    # }
    # process = {
    #   name         = "dd-process-${var.vpc_name}"
    #   service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0ed1f789ac6b0bde1"
    # }
    # profiling = {
    #   name         = "dd-profiling-${var.vpc_name}"
    #   service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-022ae36a7b2472029"
    # }
  }

  datadog_endpoints = var.enable_vpce_datadog == 1 ? local.dd_service_endpoints : {}

}
