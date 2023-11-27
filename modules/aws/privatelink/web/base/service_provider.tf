

####################
# Service Provider #
####################


# An NLB is a requirement to route traffic from a VPC Endpoint Service (Privatelink) to an ALB
resource "aws_lb" "privatelink_nlb" {

  provider = aws.service_provider

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  internal                         = true
  load_balancer_type               = "network"
  name                             = local.name
  subnets                          = data.aws_subnet_ids.provider_privatelink.ids

  access_logs {
    bucket  = "cn-alb-logs-${local.env}"
    enabled = true
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "LBType" = "network"
    "Name" = local.name }
  )
}

resource "aws_lb_target_group" "privatelink_nlb" {

  provider = aws.service_provider

  name        = local.name
  port        = var.port
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = data.aws_vpc.provider.id

  health_check {
    path     = var.service_provider_path_tg
    port     = var.port
    protocol = var.service_provider_protocol_tg
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )
}

# Attaching the service's ALB to the PrivateLink NLB target group
resource "aws_lb_target_group_attachment" "alb" {

  provider = aws.service_provider

  port             = var.port
  target_group_arn = aws_lb_target_group.privatelink_nlb.arn
  target_id        = data.aws_lb.service_provider_alb.arn
}

# Forwarding HTTPS traffic from the PrivateLink NLB to the service's ALB
resource "aws_lb_listener" "privatelink_nlb" {

  provider = aws.service_provider

  load_balancer_arn = aws_lb.privatelink_nlb.arn
  port              = var.port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.privatelink_nlb.arn
  }
}



###############
# NLB Outputs #
###############

output "nlb_name" {
  value = aws_lb.privatelink_nlb.name
}

output "nlb_arn" {
  value = aws_lb.privatelink_nlb.arn
}


output "tg_arn" {
  value = aws_lb_target_group.privatelink_nlb.arn
}


########################
# VPC Endpoint Service #
########################

# The VPC Endpoint Service (PrivateLink) on the Provider side VPC
resource "aws_vpc_endpoint_service" "privatelink" {

  provider = aws.service_provider

  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.privatelink_nlb.arn]
  private_dns_name           = var.service_provider_private_dns_name # private in this case means customer-owned DNS record/zone

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "privatelink-${var.service}-${local.env}" }
  )
}

# required to prove domain ownership to allow usage of a custom domain
resource "aws_route53_record" "privatelink_txt" {

  provider = aws.service_provider

  zone_id = data.aws_route53_zone.provider_public.zone_id
  name    = "${aws_vpc_endpoint_service.privatelink.private_dns_name_configuration[0]["name"]}."
  type    = "TXT"
  ttl     = "300"
  records = [aws_vpc_endpoint_service.privatelink.private_dns_name_configuration[0]["value"]]
}

# This allows a list of AWS accounts to connect to the VPC Endpoint Service
resource "aws_vpc_endpoint_service_allowed_principal" "allow_aws_accounts" {

  provider = aws.service_provider

  for_each = toset(var.service_provider_aws_account_ids)

  vpc_endpoint_service_id = aws_vpc_endpoint_service.privatelink.id
  principal_arn           = "arn:aws:iam::${each.key}:root"
}


#######################
# PrivateLink Outputs #
#######################
output "privatelink_service_name" {
  value = aws_vpc_endpoint_service.privatelink.service_name
}

output "privatelink_private_dns_name" {
  value = aws_vpc_endpoint_service.privatelink.private_dns_name
}
