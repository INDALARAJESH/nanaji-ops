module "some_vpc" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.2"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cidr_block      = "10.21.0.0/16"
  env             = var.env
  private_subnets = ["10.21.0.0/19", "10.21.32.0/19", "10.21.64.0/19"]
  public_subnets  = ["10.21.96.0/19", "10.21.128.0/19", "10.21.160.0/19"]
  vpc_name_prefix = "nc"

  ### optional
  extra_allowed_subnets = ["${data.aws_eip.primary_vpc_ngw.public_ip}/32"]
  privatelink_subnets   = ["10.21.230.0/23","10.21.232.0/23","10.21.234.0/23","10.21.236.0/23","10.21.238.0/23","10.21.240.0/23"]
}
