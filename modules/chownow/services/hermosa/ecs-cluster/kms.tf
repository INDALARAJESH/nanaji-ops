module "kms_key" {
  source          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/kms?ref=aws-kms-v2.0.1"
  env             = var.env
  env_inst        = var.env_inst
  key_name_prefix = "cn"
  key_name        = "ecs-execute-command-${var.service}"
  principals      = { Service = ["logs.us-east-1.amazonaws.com"] }
}
