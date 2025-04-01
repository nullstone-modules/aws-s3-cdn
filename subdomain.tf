data "ns_connection" "subdomain" {
  name     = "subdomain"
  contract = "subdomain/aws/route53"
}

locals {
  zone_id        = data.ns_connection.subdomain.outputs.zone_id
  subdomain      = trimsuffix(data.ns_connection.subdomain.outputs.fqdn, ".")
  alt_subdomains = var.enable_www ? ["www.${local.subdomain}"] : []
  all_subdomains = concat([local.subdomain], local.alt_subdomains)
  delegator      = try(data.ns_connection.subdomain.outputs.delegator, {})

  subdomain_certificate_arn = try(data.ns_connection.subdomain.outputs.certificate_arn, "")
  subdomain_has_certificate = local.subdomain_certificate_arn != ""
}

provider "aws" {
  access_key = try(local.delegator["access_key"], "")
  secret_key = try(local.delegator["secret_key"], "")

  alias = "domain"
}

// When attaching certificates to a CDN, the cert must live in the us-east-1 region
// See https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-invalid-viewer-certificate/
provider "aws" {
  region = "us-east-1"

  alias = "cert"
}
