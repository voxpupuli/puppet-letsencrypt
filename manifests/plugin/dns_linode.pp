# @summary Installs and configures the dns-linode plugin
#
# This class installs and configures the Let's Encrypt dns-linode plugin.
# https://certbot-dns-linode.readthedocs.io
#
# @param package_name The name of the package to install when $manage_package is true.
# @param api_key
#   Optional string, linode api key value for authentication.
# @param version
#   string, linode api version.
# @param config_path The path to the configuration directory.
# @param manage_package Manage the plugin package.
# @param propagation_seconds Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.
#
class letsencrypt::plugin::dns_linode (
  String[1] $api_key,
  Optional[String[1]] $package_name = undef,
  String[1] $version                = '4',
  Stdlib::Absolutepath $config_path = "${letsencrypt::config_dir}/dns-linode.ini",
  Boolean $manage_package           = true,
  Integer $propagation_seconds      = 120,
) {
  include letsencrypt

  if $manage_package {
    if ! $package_name {
      fail('No package name provided for certbot dns linode plugin.')
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

  $ini_vars = {
    dns_linode_key => $api_key,
    dns_linode_version => $version,
  }

  file { $config_path:
    ensure  => file,
    owner   => 'root',
    group   => 0,
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
        vars => { '' => $ini_vars },
      },
    ),
  }
}
