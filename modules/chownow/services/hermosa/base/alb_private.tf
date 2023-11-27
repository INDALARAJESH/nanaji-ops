// module "admin_hermosa_alb_private" {
//   source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lb/alb/private?ref=aws-alb-private-v2.0.1"

//   listener_da_type              = "forward"
//   certificate_arn               = data.aws_acm_certificate.star_chownow.arn
//   env                           = var.env
//   env_inst                      = var.env_inst
//   name_prefix                   = "ordering"
//   service                       = var.service
//   vpc_id                        = data.aws_vpc.selected.id
//   enable_http_to_https_redirect = 1
//   security_group_ids = [
//     module.internal_sg.id,
//     module.vpn_web_sg.id,
//   ]
// }

// resource "aws_alb_target_group" "admin_https" {
//   name     = "admin-${var.service}-priv-${local.env}-https"
//   port     = 443
//   protocol = "HTTPS"
//   vpc_id   = data.aws_vpc.selected.id

//   health_check {
//     path     = var.health_check_target
//     protocol = "HTTPS"
//     matcher  = "200"
//   }

//   tags = merge(
//     local.common_tags,
//     var.extra_tags,
//     map(
//       "Name", "admin-${var.service}-priv-${local.env}-https",
//     )
//   )
// }

// resource "aws_alb_listener_rule" "admin_https" {
//   listener_arn = module.admin_hermosa_alb_private.listener_arn
//   priority     = 20

//   action {
//     type             = "forward"
//     target_group_arn = aws_alb_target_group.admin_https.arn
//   }

//   condition {
//     path_pattern {
//       values = ["/admin*"]
//     }
//   }
// }

// resource "aws_route53_record" "private_api_alias" {
//   zone_id = data.aws_route53_zone.private.zone_id
//   name    = "api.${data.aws_route53_zone.private.name}"
//   type    = "A"

//   alias {
//     name                   = module.admin_hermosa_alb_private.alb_dns_name
//     zone_id                = module.admin_hermosa_alb_private.alb_private_zone_id
//     evaluate_target_health = false
//   }

//   geolocation_routing_policy {
//     country = var.geo_target
//   }

//   set_identifier = var.set_id
// }
