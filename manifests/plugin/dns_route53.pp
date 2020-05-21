# @summary Installs and configures the dns-route53 plugin
#
# This class installs and configures the Let's Encrypt dns-route53 plugin.
# https://certbot-dns-route53.readthedocs.io
#
# @param propagation_seconds Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.
# @param manage_package Manage the plugin package.
# @param package_name The name of the package to install when $manage_package is true.
#
class letsencrypt::plugin::dns_route53 (
  String[1] $package_name,
  Integer $propagation_seconds     = 10,
  Boolean $manage_package          = true,
) {
  require letsencrypt

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }
}
