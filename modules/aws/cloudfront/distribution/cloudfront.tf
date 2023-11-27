resource "aws_cloudfront_origin_access_identity" "origin" {
  comment = "${var.name_prefix}-${var.service}-access-identity-${local.env}"
}

resource "aws_s3_bucket_policy" "origin" {
  depends_on = [aws_cloudfront_origin_access_identity.origin]
  bucket     = var.bucket_name

  policy = <<POLICY
{
   "Version":"2008-10-17",
   "Id":"PolicyForCloudFrontPrivateContent",
   "Statement":[
      {
         "Sid":"1",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin.id}"
         },
         "Action":"s3:GetObject",
         "Resource":"${var.bucket_arn}/*"
      }
   ]
}
POLICY
}

resource "aws_cloudfront_distribution" "main" {
  comment     = "${var.name_prefix}-${var.service}-distribution-${local.env}"
  price_class = var.price_class

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "S3-${var.bucket_domain_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path
    }
  }

  web_acl_id = var.web_acl_id

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

      headers = var.headers
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = true

    dynamic "lambda_function_association" {
      for_each = var.lambda_function_association
      content {
        event_type = lambda_function_association.value["event_type"]
        lambda_arn = lambda_function_association.value["lambda_arn"]
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_code         = custom_error_response.value["error_code"]
      response_code      = custom_error_response.value["response_code"]
      response_page_path = custom_error_response.value["response_page_path"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  //  Use our common tags and add a specific name.
  tags = merge(
    local.common_tags,
    var.extra_tags
  )
}
