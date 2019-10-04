# @summary Install and configure Certbot, the LetsEncrypt client
#
# Install and configure Certbot, the LetsEncrypt client
#
# @example
#  class { 'letsencrypt' :
#    email  => 'letsregister@example.com',
#    config => {
#      'server' => 'https://acme-staging.api.letsencrypt.org/directory',
#    },
#  }
#
# @param email
#   The email address to use to register with Let's Encrypt. This takes
#   precedence over an 'email' setting defined in $config.
# @param path The path to the letsencrypt installation.
# @param venv_path virtualenv path for vcs-installed Certbot
# @param environment An optional array of environment variables (in addition to VENV_PATH)
# @param repo A Git URL to install the Let's encrypt client from.
# @param version The Git ref (tag, sha, branch) to check out when installing the client with the `vcs` method.
# @param package_name Name of package and command to use when installing the client with the `package` method.
# @param package_ensure The value passed to `ensure` when installing the client with the `package` method.
# @param package_command Path or name for letsencrypt executable when installing the client with the `package` method.
# @param config_file The path to the configuration file for the letsencrypt cli.
# @param config A hash representation of the letsencrypt configuration file.
# @param cron_scripts_path The path to put the script we'll call with cron. Defaults to $puppet_vardir/letsencrypt.
# @param manage_config A feature flag to toggle the management of the letsencrypt configuration file.
# @param manage_install A feature flag to toggle the management of the letsencrypt client installation.
# @param manage_dependencies A feature flag to toggle the management of the letsencrypt dependencies.
# @param configure_epel A feature flag to include the 'epel' class and depend on it for package installation.
# @param install_method Method to install the letsencrypt client, either package or vcs.
# @param agree_tos A flag to agree to the Let's Encrypt Terms of Service.
# @param unsafe_registration A flag to allow using the 'register-unsafely-without-email' flag.
# @param config_dir The path to the configuration directory.
# @param key_size Size for the RSA public key
# @param renew_pre_hook_commands Array of commands to run in a shell before obtaining/renewing any certificates.
# @param renew_post_hook_commands Array of commands to run in a shell after attempting to obtain/renew certificates.
# @param renew_deploy_hook_commands
#   Array of commands to run in a shell once for each successfully issued/renewed
#   certificate. Two environmental variables are supplied by certbot:
#   - $RENEWED_LINEAGE: Points to the live directory with the cert files and key.
#                       Example: /etc/letsencrypt/live/example.com
#   - $RENEWED_DOMAINS: A space-delimited list of renewed certificate domains.
#                       Example: "example.com www.example.com"
# @param renew_additional_args Array of additional command line arguments to pass to 'certbot renew'.
# @param renew_cron_ensure Intended state of the cron resource running certbot renew.
# @param renew_cron_hour
#   Optional string, integer or array of hour(s) the renewal command should run.
#   E.g. '[0,12]' to execute at midnight and midday. Default: fqdn-seeded random
#   hour.
# @param renew_cron_minute
#   Optional string, integer or array of minute(s) the renewal command should
#   run. E.g. 0 or '00' or [0,30]. Default: fqdn-seeded random minute.
# @param renew_cron_monthday
#   Optional string, integer or array of monthday(s) the renewal command should
#   run. E.g. '2-30/2' to run on even days. Default: Every day.
#
class letsencrypt (
  Optional[String] $email                = undef,
  String $path                           = $letsencrypt::params::path,
  $venv_path                             = $letsencrypt::params::venv_path,
  Array $environment                     = [],
  String $repo                           = $letsencrypt::params::repo,
  String $version                        = $letsencrypt::params::version,
  String $package_name                   = $letsencrypt::params::package_name,
  $package_ensure                        = $letsencrypt::params::package_ensure,
  String $package_command                = $letsencrypt::params::package_command,
  String $config_file                    = $letsencrypt::params::config_file,
  Hash $config                           = $letsencrypt::params::config,
  String $cron_scripts_path              = $letsencrypt::params::cron_scripts_path,
  Boolean $manage_config                 = $letsencrypt::params::manage_config,
  Boolean $manage_install                = $letsencrypt::params::manage_install,
  Boolean $manage_dependencies           = $letsencrypt::params::manage_dependencies,
  Boolean $configure_epel                = $letsencrypt::params::configure_epel,
  Enum['package', 'vcs'] $install_method = $letsencrypt::params::install_method,
  Boolean $agree_tos                     = $letsencrypt::params::agree_tos,
  Boolean $unsafe_registration           = $letsencrypt::params::unsafe_registration,
  Stdlib::Unixpath $config_dir           = $letsencrypt::params::config_dir,
  Integer[2048] $key_size                = 4096,
  # $renew_* should only be used in letsencrypt::renew (blame rspec)
  $renew_pre_hook_commands               = $letsencrypt::params::renew_pre_hook_commands,
  $renew_post_hook_commands              = $letsencrypt::params::renew_post_hook_commands,
  $renew_deploy_hook_commands            = $letsencrypt::params::renew_deploy_hook_commands,
  $renew_additional_args                 = $letsencrypt::params::renew_additional_args,
  $renew_cron_ensure                     = $letsencrypt::params::renew_cron_ensure,
  $renew_cron_hour                       = $letsencrypt::params::renew_cron_hour,
  $renew_cron_minute                     = $letsencrypt::params::renew_cron_minute,
  $renew_cron_monthday                   = $letsencrypt::params::renew_cron_monthday,
) inherits letsencrypt::params {

  if $manage_install {
    contain letsencrypt::install # lint:ignore:relative_classname_inclusion
    Class['letsencrypt::install'] ~> Exec['initialize letsencrypt']
    Class['letsencrypt::install'] -> Class['letsencrypt::renew']
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

  contain letsencrypt::renew

  # TODO: do we need this command when installing from package?
  exec { 'initialize letsencrypt':
    command     => "${command_init} -h",
    path        => $facts['path'],
    environment => concat([ "VENV_PATH=${venv_path}" ], $environment),
    refreshonly => true,
  }

  # Used in letsencrypt::certonly Exec["letsencrypt certonly ${title}"]
  file { '/usr/local/sbin/letsencrypt-domain-validation':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0500',
    source => "puppet:///modules/${module_name}/domain-validation.sh",
  }
}
