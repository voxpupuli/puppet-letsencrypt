# @summary Installs the Let's Encrypt client.
#
# @param configure_epel A feature flag to include the 'epel' class and depend on it for package installation.
# @param package_ensure The value passed to `ensure` when installing the client package.
# @param package_name Name of package to use when installing the client package.
#
# @api private
#
class letsencrypt::install (
  Boolean $configure_epel = $letsencrypt::configure_epel,
  String $package_name = $letsencrypt::package_name,
  String $package_ensure = $letsencrypt::package_ensure,
) {
  assert_private()

  package { 'letsencrypt':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if $configure_epel {
    include epel
    Class['epel'] -> Package['letsencrypt']
  }
}
