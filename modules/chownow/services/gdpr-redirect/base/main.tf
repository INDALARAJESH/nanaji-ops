module "gdpr_redirect_private" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/s3/base?ref=s3-base-v2.0.1"

  bucket_name = "${var.name_prefix}-gdpr-redirect-${local.env}"
  env         = var.env
  env_inst    = var.env_inst
  service     = var.service

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [{
    id      = "${var.name_prefix}-gdpr-redirect-${local.env}-abort-incomplete-multipart"
    enabled = true

    abort_incomplete_multipart_upload_days = 7
  }]
}

resource "null_resource" "gdpr_redirect_private_assets" {
  depends_on = ["module.gdpr_redirect_private"]

  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = "python3 -m venv ${path.module}/venv_gdpr_redirect_private_assets"
  }

  provisioner "local-exec" {
    command = "source ${path.module}/venv_gdpr_redirect_private_assets/bin/activate && pip install -r ${path.module}/scripts/requirements.txt"
  }

  # For some reason, the "AWS_SECURITY_TOKEN" is invalid when assuming the role - unsetting the variable still has the script working running within the local-exec
  provisioner "local-exec" {
    command = "source ${path.module}/venv_gdpr_redirect_private_assets/bin/activate && unset AWS_SECURITY_TOKEN && python3 ${path.module}/scripts/s3dirupload.py --rolearn arn:aws:iam::${local.aws_account_id}:role/${var.aws_assume_role_name} --destinationbucket ${module.gdpr_redirect_private.bucket_name} --sourcedirectory ${path.module}/assets"
  }
}

module "cloudfront" {
  source                 = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudfront/distribution?ref=aws-cloudfront-distribution-v2.0.0"
  env                    = var.env
  env_inst               = var.env_inst
  service                = var.service
  acm_certificate_arn    = data.aws_acm_certificate.main.arn
  bucket_name            = module.gdpr_redirect_private.bucket_name
  bucket_arn             = module.gdpr_redirect_private.bucket_arn
  bucket_domain_name     = module.gdpr_redirect_private.bucket_domain_name
  aliases                = var.gpdr_redirect_domains
  viewer_protocol_policy = "redirect-to-https"
  lambda_function_association = [{
    event_type = "viewer-response"
    lambda_arn = data.aws_lambda_function.lambda_sec_headers.qualified_arn
  }]
  custom_error_response = [{
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }]
}

# ---------------------------------------------------------------------------------------------------------------------
# DNS / ROUTE53
# ---------------------------------------------------------------------------------------------------------------------
module "gpdr_redirect_dns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/route53/record/basic?ref=aws-r53-record-basic-v2.0.2"
  // aws-r53-record-basic-v2.0.2"

  count             = length(var.gpdr_redirect_domains)
  name              = element(var.gpdr_redirect_domains, count.index)
  zone_id           = data.aws_route53_zone.svpn.zone_id
  ttl               = var.dns_ttl
  type              = "CNAME"
  enable_record     = 0
  records           = []
  enable_gdpr_cname = 1
  gdpr_destination  = module.cloudfront.domain_name

}
