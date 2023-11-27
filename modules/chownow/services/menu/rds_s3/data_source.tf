data "aws_rds_cluster" "menu_rds" {
  cluster_identifier = "${var.service}-mysql-${local.env}"
}
