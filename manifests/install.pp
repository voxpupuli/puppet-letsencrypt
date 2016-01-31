# == Class: letsencrypt::install
#
#   This class installs the Let's Encrypt client.  This is a private class.
#
# === Parameters:
#
# [*manage_install*]
#   A feature flag to toggle the management of the letsencrypt client
#   installation.
# [*manage_dependencies*]
#   A feature flag to toggle the management of the letsencrypt dependencies.
# [*install_method*]
#   Method to install the letsencrypt client, either package or vcs.
# [*path*]
#   The path to the letsencrypt installation.
# [*repo*]
#   A Git URL to install the Let's encrypt client from.
# [*version*]
#   The Git ref (tag, sha, branch) to check out when installing the client.
#
class letsencrypt::install (
  Boolean                $manage_install      = $letsencrypt::manage_install,
  Boolean                $manage_dependencies = $letsencrypt::manage_dependencies,
  Enum['package', 'vcs'] $install_method      = $letsencrypt::install_method,
  String                 $path                = $letsencrypt::path,
  String                 $repo                = $letsencrypt::repo,
  String                 $version             = $letsencrypt::version,
) {

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
    package { 'letsencrypt':
      ensure => installed,
    }
  }
}
