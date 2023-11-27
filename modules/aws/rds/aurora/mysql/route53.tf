######################
# DNS CNAME Creation #
######################

resource "aws_route53_record" "cluster_endpoint" {
  name    = "${local.cname_endpoint}.${var.dns_zone_name}." # eg hermosa-db-primary.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_rds_cluster.db.endpoint}."]
  zone_id = data.aws_route53_zone.dns_zone.zone_id
}

resource "aws_route53_record" "cluster_endpoint_reader" {
  name    = "${local.cname_endpoint_reader}.${var.dns_zone_name}." # eg hermosa-db-replica.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_rds_cluster.db.reader_endpoint}."]
  zone_id = data.aws_route53_zone.dns_zone.zone_id
}
