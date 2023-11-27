###################################
# Elastic Container Registry Repo #
###################################
resource "aws_ecrpublic_repository" "app" {
  repository_name = local.name
}
