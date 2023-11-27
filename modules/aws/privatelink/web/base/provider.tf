### NOTE: These are required in the module and for terraform 0.14.x to work. We can revisit this when we move up to 1.x

provider "aws" {
  alias = "service_consumer"
}

provider "aws" {
  alias = "service_provider"
}
