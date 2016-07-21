# == Class: certbot
#
#   This class installs and configures the Let's Encrypt client.
#
# === Parameters:
#
# [*email*]
#   The email address to use to register with Let's Encrypt. This takes
#   precedence over an 'email' setting defined in $config.
# [*path*]
#   The path to the certbot installation.
# [*environment*]
#   An optional array of environment variables (in addition to VENV_PATH)
# [*repo*]
#   A Git URL to install the Let's encrypt client from.
# [*version*]
#   The Git ref (tag, sha, branch) to check out when installing the client with
#   the `vcs` method.
# [*package_ensure*]
#   The value passed to `ensure` when installing the client with the `package`
#   method.
# [*package_name*]
#   Name of package and command to use when installing the client with the
#   `package` method.
# [*package_command*]
#   Path or name for certbot executable when installing the client with
#   the `package` method.
# [*config_file*]
#   The path to the configuration file for the certbot cli.
# [*config*]
#   A hash representation of the certbot configuration file.
# [*manage_config*]
#   A feature flag to toggle the management of the certbot configuration
#   file.
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
# [*agree_tos*]
#   A flag to agree to the Let's Encrypt Terms of Service.
# [*unsafe_registration*]
#   A flag to allow using the 'register-unsafely-without-email' flag.
#
class certbot (
  $email               = undef,
  $path                = $certbot::params::path,
  $venv_path           = $certbot::params::venv_path,
  $environment         = [],
  $repo                = $certbot::params::repo,
  $version             = $certbot::params::version,
  $package_name        = $certbot::params::package_name,
  $package_ensure      = $certbot::params::package_ensure,
  $package_command     = $certbot::params::package_command,
  $config_file         = $certbot::params::config_file,
  $config              = $certbot::params::config,
  $manage_config       = $certbot::params::manage_config,
  $manage_install      = $certbot::params::manage_install,
  $manage_dependencies = $certbot::params::manage_dependencies,
  $configure_epel      = $certbot::params::configure_epel,
  $install_method      = $certbot::params::install_method,
  $agree_tos           = $certbot::params::agree_tos,
  $unsafe_registration = $certbot::params::unsafe_registration,
) inherits certbot::params {
  validate_string($path, $repo, $version, $config_file, $package_name, $package_command)
  if $email {
    validate_string($email)
  }
  validate_array($environment)
  validate_bool($manage_config, $manage_install, $manage_dependencies, $configure_epel, $agree_tos, $unsafe_registration)
  validate_hash($config)
  validate_re($install_method, ['^package$', '^vcs$'])

  if $manage_install {
    contain ::certbot::install
    Class['certbot::install'] ~> Exec['initialize certbot']
  }

  if $install_method == 'package' {
    $command      = $package_command
    $command_init = $package_command
  } elsif $install_method == 'vcs' {
    $command      = "${venv_path}/bin/certbot"
    $command_init = "${path}/certbot-auto"
  }

  if $manage_config {
    contain ::certbot::config
    Class['certbot::config'] -> Exec['initialize certbot']
  }

  # TODO: do we need this command when installing from package?
  exec { 'initialize certbot':
    command     => "${command_init} -h",
    path        => $::path,
    environment => concat([ "VENV_PATH=${venv_path}" ], $environment),
    refreshonly => true,
  }
}
