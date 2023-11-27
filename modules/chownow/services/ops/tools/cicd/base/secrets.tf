module "codebuild_secrets" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/secrets/insert?ref=aws-secrets-insert-v1.0.0"

  env                = var.env
  is_kv              = true
  secret_description = "Secrets that Codebuild needs during the CI/CD pipeline"
  secret_name        = "${var.env}/${var.service}/codebuild"
  secret_kv          = map("dockerhub_pw", "REPLACE_ME")
  service            = var.service

  extra_tags = {
    CodebuildReadable = "true"
  }
}
