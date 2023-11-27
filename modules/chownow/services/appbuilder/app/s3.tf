module "appbuilder_s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=aws-s3-base-v3.0.0"

  bucket_name = "cn-${var.service}-images-${local.env}"
  env         = "${local.env}"
  service     = "${var.service}"

  extra_tags = {
    Service = "${var.service}"
  }
}
