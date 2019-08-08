# == Class: letsencrypt::plugin::dns_ovh
#
#   This class installs and configures the Let's Encrypt dns-ovh plugin.
#   https://certbot-dns-ovh.readthedocs.io
#
# === Parameters:
#
# [*endpoint*]
#   Target OVH DNS endpoint.
# [*application_key*]
#   OVH application key.
# [*application_secret*]
#   DNS OVH application secret.
# [*consumer_key*]
#   DNS OVH consumer key.
# [*manage_package*]
#   Manage the plugin package.
# [*package_name*]
#   The name of the package to install when $manage_package is true.
# [*config_dir*]
#   The path to the configuration directory.
#
class letsencrypt::plugin::dns_ovh (
  Enum['ovh-eu', 'ovh-ca'] $endpoint,
  String[1] $application_key,
  String[1] $application_secret,
  String[1] $consumer_key,
  Integer $propagation_seconds     = $letsencrypt::dns_ovh_propagation_seconds,
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Boolean $manage_package          = $letsencrypt::dns_ovh_manage_package,
  String $package_name             = $letsencrypt::dns_ovh_package_name,
) {

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  $ini_vars = {
    dns_ovh_endpoint            => $endpoint,
    dns_ovh_application_key     => $application_key,
    dns_ovh_application_secret  => $application_secret,
    dns_ovh_consumer_key        => $consumer_key,
    dns_ovh_propagation_seconds => $propagation_seconds,
  }

  file { "${config_dir}/dns-ovh.ini":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
      vars => { '' => $ini_vars },
    }),
    require => Class['letsencrypt'],
  }

}
