terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.21.0"
    }
  }

  required_version = ">= 0.14.7"
}
