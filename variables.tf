variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  // Older versions of the static site module don't have this, fallback to versioned assets
  artifacts_key_template = try(var.app_metadata["artifacts_key_template"], "{{app-version}}/")
  log_group_name         = try(var.app_metadata["log_group_name"], "")
  log_group_arn          = try(var.app_metadata["log_group_arn"], "")
}

variable "enable_www" {
  type        = bool
  description = "Enable/Disable creating www.<domain> DNS record in addition to <domain> DNS record for hosted site"
  default     = true
}

variable "default_document" {
  type        = string
  description = "The default document to use when hitting the root of the site."
  default     = "index.html"
}

variable "notfound_behavior" {
  type = object({
    enabled : bool
    spa_mode : bool
    document : string
  })

  default = {
    enabled  = true
    spa_mode = true
    document = "404.html"
  }

  description = <<EOF
This configures behavior when a file is not found.
If `spa_mode` is on, all not found errors will respond with `HTTP 200` serving `default_document`.
Otherwise, will respond with `HTTP 404` serving `document`.
EOF
}

variable "min_ttl" {
  type        = number
  default     = 0
  description = <<EOF
Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
Defaults to 0 seconds.
EOF
}

variable "default_ttl" {
  type        = number
  default     = 86400
  description = <<EOF
Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header.
EOF
}

variable "max_ttl" {
  type        = number
  default     = 31536000
  description = <<EOF
Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated.
Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers.
EOF
}

variable "cache_policy" {
  type        = string
  default     = "Managed-CachingOptimized"
  description = <<EOF
Set the policy for how the CDN caches objects.
By default, the CDN is configured with `Managed-CachingOptimized`.
You can choose a custom policy or AWS-managed policy.
All AWS-managed policies have a `Managed-` prefix.
EOF
}

variable "response_headers_policy" {
  type        = string
  default     = "Managed-CORS-with-preflight-and-SecurityHeadersPolicy"
  description = <<EOF
Set the policy for the response headers on the CDN.
By default, the CDN is configured with CORS (preflight) and security headers.
You can choose a custom policy or AWS-managed policy.
All AWS-managed policies have a `Managed-` prefix.
EOF
}
