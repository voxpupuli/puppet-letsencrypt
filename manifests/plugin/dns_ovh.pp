# @summary This class installs and configures the Let's Encrypt dns-ovh plugin.
#
# @example Basic usage
#  class { 'letsencrypt::plugin::dns_ovh':
#    endpoint           => 'ovh-eu',
#    application_key    => 'MDAwMDAwMDAwMDAw',
#    application_secret => 'MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAw',
#    consumer_key       => 'MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAw',
#  }
#  letsencrypt::certonly { 'foo':
#    domains       => ['foo.example.com', 'bar.example.com'],
#    plugin        => 'dns-ovh',
#  }
#
# @see https://certbot-dns-ovh.readthedocs.io
#
# === Parameters:
#
# @param endpoint
#   Target OVH DNS endpoint.
# @param application_key
#   OVH application key.
# @param application_secret
#   DNS OVH application secret.
# @param consumer_key
#   DNS OVH consumer key.
# @param propagation_seconds
#   DNS OVH propagation seconds (default: 30s)
# @param manage_package
#   Manage the plugin package.
# @param package_name
#   The name of the package to install when $manage_package is true.
# @param config_file
#   The name, with full abolute path, of the configuration file containing OVH credentials.
#
class letsencrypt::plugin::dns_ovh (
  Enum['ovh-eu', 'ovh-ca'] $endpoint,
  String[1] $application_key,
  String[1] $application_secret,
  String[1] $consumer_key,
  Integer $propagation_seconds      = $letsencrypt::dns_ovh_propagation_seconds,
  Boolean $manage_package           = $letsencrypt::dns_ovh_manage_package,
  String $package_name              = $letsencrypt::dns_ovh_package_name,
  Stdlib::Absolutepath $config_file = "${letsencrypt::config_dir}/dns-ovh.ini",
) {

  case $::operatingsystem {
    'Debian': {
      if versioncmp($::operatingsystemrelease, '10') < 0 {
        fail("The dns-ovh plugin is not compatible with ${::operatingsystem} ${::operatingsystemrelease}. See README.")
      }
    }
    'Ubuntu': {
      if versioncmp($::operatingsystemrelease, '19') < 0 {
        fail("The dns-ovh plugin is not compatible with ${::operatingsystem} ${::operatingsystemrelease}. See README.")
      }
    }
    default: {
    }
  }

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

  file { $config_file:
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
