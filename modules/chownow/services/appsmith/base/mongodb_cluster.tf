resource "aws_key_pair" "mongodb_ssh_key" {
  key_name   = "${var.service}-${local.env}"
  public_key = local.mongodb_keypair_pub_key

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-${local.env}",
    )
  )
}

module "mongodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/mongodb?ref=aws-ec2-mongodb-v2.0.3"

  dns_zone          = "${local.env}.aws.chownow.com"
  env               = var.env
  mongodb_instances = local.mongodb_instances
  service           = var.service
  vpc_name          = local.vpc_name
}
