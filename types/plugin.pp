# @summary List of accepted plugins
type Letsencrypt::Plugin = Enum[
  'apache',
  'standalone',
  'webroot',
  'nginx',
  'dns-azure',
  'dns-route53',
  'dns-google',
  'dns-cloudflare',
  'dns-linode',
  'dns-rfc2136',
  'dns-gandi',
  'manual',
]
