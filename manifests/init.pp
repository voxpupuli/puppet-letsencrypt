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
#   Path or name for letsencrypt executable when installing the client with
#   the `package` method. 
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
# [*configure_epel*]
#   A feature flag to include the 'epel' class and depend on it for package
#   installation.
# [*install_method*]
#   Method to install the letsencrypt client, either package or vcs.
# [*agree_tos*]
#   A flag to agree to the Let's Encrypt Terms of Service.
# [*unsafe_registration*]
#   A flag to allow using the 'register-unsafely-without-email' flag.
#
class letsencrypt (
  $email               = undef,
  $path                = $letsencrypt::params::path,
  $venv_path           = $letsencrypt::params::venv_path,
  $environment         = [],
  $repo                = $letsencrypt::params::repo,
  $version             = $letsencrypt::params::version,
  $package_name        = $letsencrypt::params::package_name,
  $package_ensure      = $letsencrypt::params::package_ensure,
  $package_command     = $letsencrypt::params::package_command,
  $config_file         = $letsencrypt::params::config_file,
  $config              = $letsencrypt::params::config,
  $manage_config       = $letsencrypt::params::manage_config,
  $manage_install      = $letsencrypt::params::manage_install,
  $manage_dependencies = $letsencrypt::params::manage_dependencies,
  $configure_epel      = $letsencrypt::params::configure_epel,
  $install_method      = $letsencrypt::params::install_method,
  $agree_tos           = $letsencrypt::params::agree_tos,
  $unsafe_registration = $letsencrypt::params::unsafe_registration,
) inherits letsencrypt::params {
  validate_string($path, $repo, $version, $config_file, $package_name, $package_command)
  if $email {
    validate_string($email)
  }
  validate_array($environment)
  validate_bool($manage_config, $manage_install, $manage_dependencies, $configure_epel, $agree_tos, $unsafe_registration)
  validate_hash($config)
  validate_re($install_method, ['^package$', '^vcs$'])

  if $manage_install {
    contain letsencrypt::install # lint:ignore:relative_classname_inclusion
    Class['letsencrypt::install'] ~> Exec['initialize letsencrypt']
  }

  $command = $install_method ? {
    'package' => $package_command,
    'vcs'     => "${venv_path}/bin/letsencrypt",
  }

  $command_init = $install_method ? {
    'package' => $package_command,
    'vcs'     => "${path}/letsencrypt-auto",
  }

  if $manage_config {
    contain letsencrypt::config # lint:ignore:relative_classname_inclusion
    Class['letsencrypt::config'] -> Exec['initialize letsencrypt']
  }

  # TODO: do we need this command when installing from package?
  exec { 'initialize letsencrypt':
    command     => "${command_init} -h",
    path        => $::path,
    environment => concat([ "VENV_PATH=${venv_path}" ], $environment),
    refreshonly => true,
  }
}
