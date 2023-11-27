##########################
# Matillion EC2 Instance #
##########################

module "web" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ec2/basic?ref=aws-ec2-basic-v2.0.2"

  custom_ami_id               = local.ami
  custom_vpc_name             = local.vpc_name
  custom_iam_instance_profile = aws_iam_instance_profile.matillion.name
  env                         = var.env
  env_inst                    = var.env_inst
  ingress_tcp_allowed         = var.ingress_tcp_allowed
  instance_type               = var.instance_type
  root_volume_size            = var.root_volume_size
  service                     = var.service

  extra_tags = {
    Owner = var.tag_owner
  }
}


############################
# Target Group Association #
############################

resource "aws_lb_target_group_attachment" "web" {
  count = length(module.web.ids)

  port             = var.tg_port
  target_group_arn = data.aws_lb_target_group.public_alb_http.arn
  target_id        = element(module.web.ids, count.index)
}
