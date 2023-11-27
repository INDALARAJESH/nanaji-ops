resource "aws_route53_record" "orchestrator_agent_dns_name" {
  zone_id = data.aws_route53_zone.private_vpc_zone.zone_id
  name    = "sysdig-fargate-orchestrator-nlb.${local.env}.aws.chownow.com"
  type    = "CNAME"
  ttl     = 900
  records = [aws_lb.ecs_orchestrator_agent.dns_name]
}
