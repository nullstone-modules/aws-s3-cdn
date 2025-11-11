locals {
  dims = tomap({
    "DistributionId" = aws_cloudfront_distribution.this.id
  })

  metric_name_prefix = "cdn/${random_string.resource_suffix.result}"

  metrics = [
    {
      name = "${local.metric_name_prefix}/requests"
      type = "generic"
      unit = "count"

      mappings = {
        requests_total = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/CloudFront"
          metric_name = "Requests"
          dimensions  = local.dims
        }
        requests_5xx = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/CloudFront"
          metric_name = "4xxErrorRate"
          dimensions  = local.dims
        }
        requests_4xx = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/CloudFront"
          metric_name = "5xxErrorRate"
          dimensions  = local.dims
        }
      }
    },
    {
      name = "${local.metric_name_prefix}/transfer"
      type = "generic"
      unit = "bytes"

      mappings = {
        download = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/CloudFront"
          metric_name = "BytesDownloaded"
          dimensions  = local.dims
        }
        upload = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/CloudFront"
          metric_name = "BytesUploaded"
          dimensions  = local.dims
        }
      }
    }
  ]
}
