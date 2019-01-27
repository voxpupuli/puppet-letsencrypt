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
# [*manage_package*]
#   Manage the plugin package.
# [*config_dir*]
#   The path to the configuration directory.
#
class letsencrypt::plugin::dns_rfc2136 (
  Stdlib::Host $server,
  String[1] $key_name,
  String[1] $key_secret,
  String[1] $key_algorithm         = $letsencrypt::params::dns_rfc2136_algorithm,
  Stdlib::Port $port               = $letsencrypt::params::dns_rfc2136_port,
  Integer $propagation_seconds     = $letsencrypt::params::dns_rfc2136_propagation_seconds,
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Boolean $manage_package          = $letsencrypt::params::dns_rfc2136_manage_package,
) {

  if ($manage_package) {
    package { 'python2-certbot-dns-rfc2136':
      ensure => installed,
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
