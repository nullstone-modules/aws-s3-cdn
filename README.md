# CDN for S3 Site

Creates an AWS CloudFront Distribution (CDN) with an SSL Certificate against a subdomain created as another block.



## Inputs

- `enable_www: bool` - (Default: true) Enable/Disable creating www.<domain> DNS record 
in addition to <subdomain> DNS record for site hosted on CDN
- `redirect_www: bool` - (Default: false) Redirect `www.<domain>` to `<domain>` with an `HTTP 301`, preserving path and query string.
  Requires `enable_www = true`. When false, `www.<domain>` serves the same content as `<domain>`.
- `enable_404page: bool` - (Default: false) Enable/Disable custom 404 page within s3 bucket. If enabled, bucket must contain 404.html.
- `clean_urls: object` - (Default: `{ enabled = false, mode = "redirect" }`) Serve extension-less URLs for sites whose files end in `.html`.
  A CloudFront Function maps `/page` to `/page.html` and `/dir/` to `/dir/index.html`; requests that already name a file pass through.
  `mode = "redirect"` answers `/page` with an `HTTP 301` to `/page.html`, keeping `.html` canonical (use this for an existing site to avoid re-indexing).
  `mode = "rewrite"` serves `/page.html` at `/page` silently, making the extension-less URL canonical (use this for a new site, or with VitePress `cleanUrls: true`).

## Outputs

- `cdn_arn: string` - CloudFront Distribution ARN
- `cert_arn: string` - SSL Certificate ARN