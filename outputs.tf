output "origin_access_identities" {
  value = [
    {
      iam_arn = aws_cloudfront_origin_access_identity.this.iam_arn
    }
  ]
}

output "cdns" {
  value = [
    {
      id  = aws_cloudfront_distribution.this.id
      arn = aws_cloudfront_distribution.this.arn
    }
  ]
}

locals {
  public_fqdns = concat([aws_route53_record.subdomain-root.fqdn], aws_route53_record.subdomain-www.*.fqdn)
}

output "public_urls" {
  value = [for pu in local.public_fqdns : { url = "https://${trimsuffix(pu, ".")}" }]
}

output "metrics" {
  value = [
    for m in local.metrics : {
      name     = m.name
      type     = m.type
      unit     = m.unit
      mappings = jsonencode(m.mappings)
    }
  ]
}
