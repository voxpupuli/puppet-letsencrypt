# @summary install and configure the Let's Encrypt apache plugin
#
# @param manage_package Manage the plugin package.
# @param package_name The name of the package to install when $manage_package is true.
class letsencrypt::plugin::apache (
  Boolean $manage_package = true,
  String[1] $package_name = 'python3-certbot-apache',
) {
  include letsencrypt

  if $manage_package {
    $requirement = if $letsencrypt::configure_epel {
      Class['epel']
    } else {
      undef
    }

    package { $package_name:
      ensure  => $letsencrypt::package_ensure,
      require => $requirement,
    }
  }
}
