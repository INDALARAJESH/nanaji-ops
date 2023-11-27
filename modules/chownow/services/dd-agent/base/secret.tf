module "secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  for_each = toset(local.secret_list)

  description = "${var.service} secret"
  env         = var.env
  secret_name = each.value
  service     = var.service
}
