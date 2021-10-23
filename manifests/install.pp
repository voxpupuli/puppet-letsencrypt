# @summary Installs the Let's Encrypt client.
#
# @param configure_epel A feature flag to include the 'epel' class and depend on it for package installation.
# @param package_ensure The value passed to `ensure` when installing the client package.
# @param package_name Name of package to use when installing the client package.
# @param dnfmodule_version The yum module stream version to enable on EL8 and greater variants using the `package` method with the `dnfmodule` provider.
#
class letsencrypt::install (
  Boolean $configure_epel                = $letsencrypt::configure_epel,
  String $package_name                   = $letsencrypt::package_name,
  String $package_ensure                 = $letsencrypt::package_ensure,
  String[1] $dnfmodule_version           = $letsencrypt::dnfmodule_version,
) {
  if ($facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] >= '8') {
    package { 'enable python module stream':
      name        => $dnfmodule_version,
      enable_only => true,
      provider    => 'dnfmodule',
      before      => Package['letsencrypt'],
    }
  }

  package { 'letsencrypt':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if $configure_epel {
    include epel
    Class['epel'] -> Package['letsencrypt']
  }
}
