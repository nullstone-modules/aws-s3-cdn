locals {
  normalized_404_page = "/${trimprefix(var.notfound_behavior.document, "/")}"
  normal_404_behavior = {
    error_code    = 404,
    response_code = 404,
    cache_ttl     = 0,
    path          = local.normalized_404_page
  }
  normalized_default_doc = "/${trimprefix(var.default_document, "/")}"
  spa_404_behavior = {
    error_code    = 404
    response_code = 200
    cache_ttl     = 0,
    path          = local.normalized_default_doc
  }
  custom_404 = var.notfound_behavior.spa_mode ? local.spa_404_behavior : local.normal_404_behavior

  custom_errors = var.notfound_behavior.enabled ? [local.custom_404] : []

  s3_domain_name   = var.app_metadata["s3_domain_name"]
  s3_origin_id     = "S3-${var.app_metadata["s3_bucket_id"]}"
  s3_env_origin_id = "S3-Env-${var.app_metadata["s3_bucket_id"]}"

  // Use artifacts_key_template injected by the app module
  // A valid origin_path has a preceding `/` and no trailing `/`
  // `/` is invalid -- this will force empty string
  artifacts_dir = trimprefix(replace(local.artifacts_key_template, "{{app-version}}", local.app_version), "/")
  origin_path   = trimsuffix("/${local.artifacts_dir}", "/")
}

data "aws_cloudfront_cache_policy" "this" {
  name = var.cache_policy
}

data "aws_cloudfront_response_headers_policy" "this" {
  name = var.response_headers_policy
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  price_class         = "PriceClass_All"
  comment             = "Managed by Terraform"
  tags                = local.tags
  aliases             = local.all_subdomains
  default_root_object = var.default_document

  viewer_certificate {
    acm_certificate_arn      = local.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = local.s3_domain_name
    origin_id   = local.s3_origin_id

    origin_path = local.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = local.s3_domain_name
    origin_id   = local.s3_env_origin_id
    origin_path = ""

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD", "OPTIONS"]
    target_origin_id           = local.s3_origin_id
    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = var.min_ttl
    default_ttl                = var.default_ttl
    max_ttl                    = var.max_ttl
    cache_policy_id            = data.aws_cloudfront_cache_policy.this.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.this.id
    compress                   = true
  }

  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    path_pattern               = "env.json"
    target_origin_id           = local.s3_env_origin_id
    viewer_protocol_policy     = "https-only"
    min_ttl                    = var.min_ttl
    default_ttl                = var.default_ttl
    max_ttl                    = var.max_ttl
    cache_policy_id            = data.aws_cloudfront_cache_policy.this.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.this.id
    compress                   = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "custom_error_response" {
    for_each = local.custom_errors

    content {
      error_code            = custom_error_response.value["error_code"]
      error_caching_min_ttl = custom_error_response.value["cache_ttl"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = custom_error_response.value["path"]
    }
  }
}
