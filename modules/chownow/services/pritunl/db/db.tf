module "mongodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/mongodb?ref=aws-ec2-mongodb-v2.0.3"

  dns_zone          = local.dns_zone
  env               = var.env
  mongodb_instances = var.mongodb_instances
  service           = var.service
  vpc_name          = var.vpc_name
}
