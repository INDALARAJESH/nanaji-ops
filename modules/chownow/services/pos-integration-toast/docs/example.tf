module "pos_toast" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/pos-integration-toast?ref=pos-integration-toast-v1.6.6"

  env         = var.env
  env_inst    = var.env_inst
  toast_url   = "https://ws-api.toasttab.com"
  hermosa_url = "https://api.chownow.com"

  # This is the client name for the Toast creds used in this environment
  # Toast requires uppercase name + colon format
  toast_external_id_prefix = "CHOWNOW:"

  # this is ignored and updated via the Github Actions pipeline for the pos-toast-service repo
  lambda_image_tag = "f3eeac9d6"

  source_vpc_endpoint_ids = ["vpce-123456789"]

  enable_dynamo_pitr = true
}
