###################################
# Elastic Container Registry Repo #
###################################
resource "aws_ecr_repository" "app" {
  name                 = local.name
  image_tag_mutability = local.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.enable_container_scanning
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )
}

##########################
# ECR Lifecycle Policies #
##########################
resource "aws_ecr_lifecycle_policy" "basic" {
  count = var.enable_lifecycle_policy == 1 ? 1 : 0

  repository = aws_ecr_repository.app.name

  # this is a dumb work around because templates don't accept lists as variables
  # and trying to convert a list to a string with the proper format is silly.
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": ${var.semver_rule_priority},
            "description": "Keep last ${var.semver_count} ${var.semver_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.semver_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.semver_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.feature_rule_priority},
            "description": "Keep last ${var.feature_count} ${var.feature_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.feature_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.feature_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.base_rule_priority},
            "description": "Keep last ${var.base_count} ${var.base_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.base_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.base_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.pr_rule_priority},
            "description": "Keep last ${var.pr_count} ${var.pr_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.pr_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.pr_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.branch_develop_rule_priority},
            "description": "Keep last ${var.branch_develop_count} ${var.branch_develop_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.branch_develop_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.branch_develop_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.branch_staging_rule_priority},
            "description": "Keep last ${var.branch_staging_count} ${var.branch_staging_prefix} tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["${lower(var.branch_staging_prefix)}"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.branch_staging_count}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": ${var.untagged_rule_priority},
            "description": "Keep last ${var.untagged_count} untagged images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.untagged_count}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "custom" {
  count = var.enable_lifecycle_policy != 1 && length(var.custom_lifecycle_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.app.name
  policy     = var.custom_lifecycle_policy
}

#########################
# ECR Repository Policy #
#########################

resource "aws_ecr_repository_policy" "custom" {
  count = length(var.repository_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.app.name
  policy     = var.repository_policy
}

resource "aws_ecr_repository_policy" "built_in" {
  count = length(var.repository_policy) == 0 ? 1 : 0

  repository = aws_ecr_repository.app.name
  policy     = local.ecr_policy
}
