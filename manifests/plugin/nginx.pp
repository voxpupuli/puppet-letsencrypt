# @summary install and configure the Let's Encrypt nginx plugin
#
# @param manage_package Manage the plugin package.
# @param package_name The name of the package to install when $manage_package is true.
class letsencrypt::plugin::nginx (
  Boolean $manage_package = true,
  String[1] $package_name = 'python3-certbot-nginx',
) {
  include letsencrypt

  if $manage_package {
    package { $package_name:
      ensure => $letsencrypt::package_ensure,
    }
  }
}
