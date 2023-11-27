###############
# General AWS #
###############
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


#######
# ALB #
#######

data "aws_lb_target_group" "selected_2" {
  name = "${var.service}-pub-${local.env}-${var.container_port_2}"
}

#######
# VPC #
#######

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}


###############
# ECS Cluster #
###############

data "aws_ecs_cluster" "selected" {
  cluster_name = local.cluster_name
}

#######
# EFS #
#######
data "aws_efs_file_system" "selected" {
  creation_token = "efs-${var.service}-${var.env}-${var.env_inst}"
}

###################
# Secrets Manager #
###################
data "aws_secretsmanager_secret" "appsmith" {
  name = "mongodb-${var.service}-${local.env}-appsmithrw-mongodbURI"
}

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

###########
# Logging #
###########

data "aws_ssm_parameter" "fluentbit_image" {
  name = "${var.fluentbit_container_ssm_parameter_name}/${var.fluentbit_container_image_version}"
}
