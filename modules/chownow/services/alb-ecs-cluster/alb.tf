## Public ALB Resources
module "alb_public" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/public?ref=aws-alb-public-v2.0.3"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
  vpc_id   = data.aws_vpc.selected.id

  # Access Logs
  access_logs_enabled = false

  # Listener
  certificate_arn     = data.aws_acm_certificate.public.arn
  cname_subdomain_alb = "" # route53 records handled per each deployments that share this ALB

  security_group_ids = [
    data.aws_security_group.vpn_sg.id,
  ]
}
