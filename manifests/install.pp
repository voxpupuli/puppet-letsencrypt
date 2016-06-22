# == Class: certbot::install
#
#   This class installs the Let's Encrypt client.  This is a private class.
#
# === Parameters:
#
# [*manage_install*]
#   A feature flag to toggle the management of the certbot client
#   installation.
# [*manage_dependencies*]
#   A feature flag to toggle the management of the certbot dependencies.
# [*configure_epel*]
#   A feature flag to include the 'epel' class and depend on it for package
#   installation.
# [*install_method*]
#   Method to install the certbot client, either package or vcs.
# [*path*]
#   The path to the certbot installation.
# [*repo*]
#   A Git URL to install the Let's encrypt client from.
# [*version*]
#   The Git ref (tag, sha, branch) to check out when installing the client with
#   the `vcs` method.
# [*package_ensure*]
#   The value passed to `ensure` when installing the client with the `package`
#   method.
# [*package_name*]
#   Name of package to use when installing the client with the `package`
#   method.
#
class certbot::install (
  $manage_install      = $certbot::manage_install,
  $manage_dependencies = $certbot::manage_dependencies,
  $configure_epel      = $certbot::configure_epel,
  $install_method      = $certbot::install_method,
  $package_name        = $certbot::package_name,
  $package_ensure      = $certbot::package_ensure,
  $path                = $certbot::path,
  $repo                = $certbot::repo,
  $version             = $certbot::version,
) {
  validate_bool($manage_install, $manage_dependencies, $configure_epel)
  validate_re($install_method, ['^package$', '^vcs$'])
  validate_string($path, $repo, $version, $package_name)

  if $install_method == 'vcs' {
    if $manage_dependencies {
      $dependencies = ['python', 'git']
      ensure_packages($dependencies)
      Package[$dependencies] -> Vcsrepo[$path]
    }

    vcsrepo { $path:
      ensure   => present,
      provider => git,
      source   => $repo,
      revision => $version,
    }
  } else {
    package { 'certbot':
      ensure => $package_ensure,
      name   => $package_name,
    }

    if $configure_epel {
      include ::epel
      Class['epel'] -> Package['certbot']
    }
  }
}
