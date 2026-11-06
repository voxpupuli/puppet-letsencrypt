# @summary Installs and configures the dns-azure plugin
#
# This class installs the Let's Encrypt dns-azure plugin package and exposes
# the plugin config path used by letsencrypt::certonly.
#
# @param package_name The name of the package to install when $manage_package is true.
# @param config_path The path to the plugin credentials/config file.
# @param manage_package Manage the plugin package.
# @param propagation_seconds Number of seconds to wait for DNS propagation.
#
class letsencrypt::plugin::dns_azure (
  Optional[String[1]] $package_name      = undef,
  Stdlib::Absolutepath $config_path      = "${letsencrypt::config_dir}/azure.ini",
  Boolean $manage_package                = true,
  Integer $propagation_seconds           = 10,
) {
  include letsencrypt

  if $manage_package {
    if ! $package_name {
      fail('No package name provided for certbot dns azure plugin.')
    }

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
