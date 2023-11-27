terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.9.1"
    }
  }
  required_version = ">= 0.14"
}
