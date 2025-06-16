module "cert" {
  source  = "nullstone-modules/sslcert/aws"
  enabled = !local.subdomain_has_certificate

  domain = {
    name    = local.subdomain
    zone_id = local.zone_id
  }

  alternative_names = local.alt_subdomains
  tags              = local.tags

  providers = {
    aws        = aws.cert
    aws.domain = aws.domain
  }
}

locals {
  certificate_arn = local.subdomain_has_certificate ? local.subdomain_certificate_arn : module.cert.certificate_arn
}
