# == Class: letsencrypt
#
#   This class installs and configures the Let's Encrypt client.
#
# === Parameters:
#
# [*email*]
#   The email address to use to register with Let's Encrypt. This takes
#   precedence over an 'email' setting defined in $config.
# [*path*]
#   The path to the letsencrypt installation.
# [*repo*]
#   A Git URL to install the Let's encrypt client from.
# [*version*]
#   The Git ref (tag, sha, branch) to check out when installing the client.
# [*config_file*]
#   The path to the configuration file for the letsencrypt cli.
# [*config*]
#   A hash representation of the letsencrypt configuration file.
# [*manage_config*]
#   A feature flag to toggle the management of the letsencrypt configuration
#   file.
# [*manage_install*]
#   A feature flag to toggle the management of the letsencrypt client
#   installation.
# [*manage_dependencies*]
#   A feature flag to toggle the management of the letsencrypt dependencies.
# [*install_method*]
#   Method to install the letsencrypt client, either package or vcs.
# [*agree_tos*]
#   A flag to agree to the Let's Encrypt Terms of Service.
# [*unsafe_registration*]
#   A flag to allow using the 'register-unsafely-without-email' flag.
#
class letsencrypt (
  Optional[String]       $email               = undef,
  String                 $path                = $letsencrypt::params::path,
  String                 $repo                = $letsencrypt::params::repo,
  String                 $version             = $letsencrypt::params::version,
  String                 $config_file         = $letsencrypt::params::config_file,
  Hash[String, Any]      $config              = $letsencrypt::params::config,
  Boolean                $manage_config       = $letsencrypt::params::manage_config,
  Boolean                $manage_install      = $letsencrypt::params::manage_install,
  Boolean                $manage_dependencies = $letsencrypt::params::manage_dependencies,
  Enum['package', 'vcs'] $install_method      = $letsencrypt::install_method,
  Boolean                $agree_tos           = $letsencrypt::params::agree_tos,
  Boolean                $unsafe_registration = $letsencrypt::params::unsafe_registration,
) inherits letsencrypt::params {

  if $manage_install {
    contain letsencrypt::install
    Class['letsencrypt::install'] ~> Exec['initialize letsencrypt']
  }

  $command = $install_method ? {
    'package' => 'letsencrypt',
    'vcs'     => "${path}/letsencrypt-auto",
  }

  if $manage_config {
    contain letsencrypt::config
    Class['letsencrypt::config'] -> Exec['initialize letsencrypt']
  }

  exec { 'initialize letsencrypt':
    command     => "${command} -h",
    path        => $::path,
    refreshonly => true,
  }
}
