######################
# DNS CNAME Creation #
######################

# Private Zone
resource "aws_route53_record" "private_cluster_endpoint" {
  count = local.is_private

  name    = format("%s.%s.", local.cname_endpoint, local.dns_zone) # eg hermosa-db-primary.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = [format("%s.", aws_rds_cluster.db.endpoint)]
  zone_id = data.aws_route53_zone.private[count.index].zone_id

}

resource "aws_route53_record" "private_cluster_endpoint_reader" {
  count = local.is_private

  name    = format("%s.%s.", local.cname_endpoint_reader, local.dns_zone) # eg hermosa-db-replica.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = [format("%s.", aws_rds_cluster.db.reader_endpoint)]
  zone_id = data.aws_route53_zone.private[count.index].zone_id

}

# Public Zone
resource "aws_route53_record" "public_cluster_endpoint" {
  count = local.is_private == 0 ? 1 : 0

  name    = format("%s.%s.", local.cname_endpoint, local.dns_zone) # eg hermosa-db-primary.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = [format("%s.", aws_rds_cluster.db.endpoint)]
  zone_id = data.aws_route53_zone.public[count.index].zone_id

}

resource "aws_route53_record" "public_cluster_endpoint_reader" {
  count = local.is_private == 0 ? 1 : 0

  name    = format("%s.%s.", local.cname_endpoint_reader, local.dns_zone) # eg hermosa-db-replica.uat.aws.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = [format("%s.", aws_rds_cluster.db.reader_endpoint)]
  zone_id = data.aws_route53_zone.public[count.index].zone_id
}
