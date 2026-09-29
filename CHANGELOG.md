# 0.13.0 (Sep 29, 2026)
* Added `redirect_www` to answer requests for `www.<domain>` with a `301` to `https://<domain>`, preserving path and query string.
  Off by default; existing distributions are unchanged.

# 0.12.1 (Sep 28, 2026)
* Fixed packaging: include `functions/*` so the `clean_urls` CloudFront Function template ships with the module.

# 0.12.0 (Sep 28, 2026)
* Added `clean_urls` to serve extension-less URLs via a CloudFront Function.
  `mode = "redirect"` (default) answers `/page` with a `301` to `/page.html`; `mode = "rewrite"` serves the file silently.
  Off by default; existing distributions are unchanged.

# 0.11.0 (Mar 13, 2026)
* Removed `min_ttl`, `default_ttl`, and `max_ttl` since they are not used with a managed cache policy.

# 0.10.0 (Nov 11, 2025)
* Added access logs to CloudFront distribution (accessible via Nullstone logs).
* Added metrics mappings to show CloudFront metrics in Nullstone.

# 0.9.4 (Jun 16, 2025)
* Fixed skip certificate creation when subdomain has a certificate already.

# 0.9.3 (Jun 16, 2025)
* Use SSL certificate from connected subdomain if it created one.
* Added terraform lock file.

# 0.9.2 (Nov 16, 2023)
* Enable automatic compression for site assets and `env.json`.

# 0.9.1 (May 15, 2023)
* Fixed default cache policy. Changed to `Managed-CachingOptimized`.
* Fixed default response headers policy. Changed to `Managed-CORS-with-preflight-and-SecurityHeadersPolicy`.

# 0.9.0 (May 15, 2023)
* Allow configuration of Cache Policy. Default: `CachingOptimized`
* Allow configuration of Response Headers Policy. Default: `CORS-with-preflight-and-SecurityHeadersPolicy`
* Add variables `min_ttl`, `default_ttl`, and `max_ttl` to configure caching.
