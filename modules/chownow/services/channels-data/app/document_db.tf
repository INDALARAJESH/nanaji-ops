output "cds_membership_sg" {
  value       = aws_security_group.cds_membership.id
  description = "security group that allows mongodb traffic from group members"
}

resource "aws_security_group" "cds_membership" {
  name        = "cds-docdb-membership"
  description = "channels data service: allow-from-self group containing docdb and lambda function"
  vpc_id      = data.aws_subnet.subnet_metadata.vpc_id

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "cds_docdb" {
  cluster_identifier_prefix = "channels-data-"

  db_subnet_group_name   = aws_docdb_subnet_group.cds.name
  port                   = 27017
  vpc_security_group_ids = [aws_security_group.cds_membership.id]

  # aws docdb describe-db-engine-versions --engine docdb
  engine         = "docdb"
  engine_version = "4.0.0"

  # these are in 1pass, "channels data service documentdb"
  master_password = "placeholderValue"
  master_username = "placeholderValue"

  # maintenance on thursdays, 12:30 to 1:00 AM pdt
  # daily backups at midnight pdt, keep the last 2
  backup_retention_period      = 2
  preferred_backup_window      = "07:00-07:30"
  preferred_maintenance_window = "thu:07:30-thu:08:00"
  tags = {
    "VPC" = "nc-${local.env}"
  }
  tags_all = {
    "VPC" = "nc-${local.env}"
  }
}

# the only requested instance for now, in all environments. same size everywhere
resource "aws_docdb_cluster_instance" "cds_i1" {
  cluster_identifier = aws_docdb_cluster.cds_docdb.id
  identifier_prefix  = "channels-data-"
  instance_class     = "db.t3.medium"

  # maintenance window is the same as the cluster
  preferred_maintenance_window = "thu:07:30-thu:08:00"
}

resource "aws_docdb_subnet_group" "cds" {
  name_prefix = "channels-data-"
  subnet_ids  = var.vpc_placement_subnets
}

