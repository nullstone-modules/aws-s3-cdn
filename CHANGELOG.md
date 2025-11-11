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
