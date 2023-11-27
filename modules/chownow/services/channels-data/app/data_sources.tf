data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# used for extracting the vpc id from the lambda function's network environment
data "aws_subnet" "subnet_metadata" {
  id = var.vpc_placement_subnets[0]
}
