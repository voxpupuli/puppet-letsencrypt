# == Class: letsencrypt::plugin::dns_rfc2136
#
#   This class installs and configures the Let's Encrypt dns-rfc2136 plugin.
#   https://certbot-dns-rfc2136.readthedocs.io
#
# === Parameters:
#
# [*server*]
#   Target DNS server.
# [*key_name*]
#   TSIG key name.
# [*key_secret*]
#   TSIG key secret.
# [*key_algorithm*]
#   TSIG key algorithm.
# [*port*]
#   Target DNS port.
# [*propagation_seconds*]
#   Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.
# [*manage_package*]
#   Manage the plugin package.
# [*package_name*]
#   The name of the package to install when $manage_package is true.
# [*config_dir*]
#   The path to the configuration directory.
#
class letsencrypt::plugin::dns_rfc2136 (
  Stdlib::Host $server,
  String[1] $key_name,
  String[1] $key_secret,
  String[1] $key_algorithm         = $letsencrypt::dns_rfc2136_algorithm,
  Stdlib::Port $port               = $letsencrypt::dns_rfc2136_port,
  Integer $propagation_seconds     = $letsencrypt::dns_rfc2136_propagation_seconds,
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Boolean $manage_package          = $letsencrypt::dns_rfc2136_manage_package,
  String $package_name             = $letsencrypt::dns_rfc2136_package_name,
) {

  if $manage_package {
    package { $package_name:
      ensure => installed,
      install_options => $operatingsystemmajrelease ? {
        '8'     => '--enablerepo=powertools',
        default => undef,
      },
    }
  }

  $ini_vars = {
    dns_rfc2136_server    => $server,
    dns_rfc2136_port      => $port,
    dns_rfc2136_name      => $key_name,
    dns_rfc2136_secret    => $key_secret,
    dns_rfc2136_algorithm => $key_algorithm,
  }

  file { "${config_dir}/dns-rfc2136.ini":
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
