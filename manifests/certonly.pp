# == Defined Type: letsencrypt::certonly
#
#   This type can be used to request a certificate using the `certonly`
#   installer.
#
# === Parameters:
#
# [*domains*]
#   Namevar. An array of domains to include in the CSR.
# [*custom_plugin*]
#   Whether to use a custom plugin in additional_args and disable -a flag.
# [*plugin*]
#   The authenticator plugin to use when requesting the certificate.
# [*webroot_paths*]
#   An array of webroot paths for the domains in `domains`.
#   Required if using `plugin => 'webroot'`. If `domains` and
#   `webroot_paths` are not the same length, the last `webroot_paths`
#   element will be used for all subsequent domains.
# [*letsencrypt_command*]
#   Command to run letsencrypt
# [*additional_args*]
#   An array of additional command line arguments to pass to the
#   `letsencrypt-auto` command.
# [*environment*]
#   An optional array of environment variables (in addition to VENV_PATH).
# [*manage_cron*]
#   Boolean indicating whether or not to schedule cron job for renewal.
#   Runs daily but only renews if near expiration, e.g. within 10 days.
# [*cron_before_command*]
#   String representation of a command that should be run before renewal command
# [*cron_success_command*]
#   String representation of a command that should be run if the renewal command
#   succeeds.
# [*cron_hour*]
#   Optional string, integer or array, hour(s) that the renewal command should execute.
#   e.g. '[0,12]' execute at midnight and midday.  Default - seeded random hour.
# [*cron_minute*]
#   Optional string, integer or array, minute(s) that the renewal command should execute.
#   e.g. 0 or '00' or [0,30].  Default - seeded random minute.
#
define letsencrypt::certonly (
  Array[String[1]]                          $domains              = [$title],
  Boolean                                   $custom_plugin        = false,
  Letsencrypt::Plugin                       $plugin               = 'standalone',
  Array[Stdlib::Unixpath]                   $webroot_paths        = [],
  String[1]                                 $letsencrypt_command  = $letsencrypt::command,
  Array[String[1]]                          $additional_args      = [],
  Array[String[1]]                          $environment          = [],
  Boolean                                   $manage_cron          = false,
  Boolean                                   $suppress_cron_output = false,
  Optional[String[1]]                       $cron_before_command  = undef,
  Optional[String[1]]                       $cron_success_command = undef,
  Array[Variant[Integer[0, 59], String[1]]] $cron_monthday        = ['*'],
  Variant[Integer[0,23], String, Array]     $cron_hour            = fqdn_rand(24, $title),
  Variant[Integer[0,59], String, Array]     $cron_minute          = fqdn_rand(60, fqdn_rand_string(10, $title)),
  Stdlib::Unixpath                          $config_dir           = $letsencrypt::config_dir,
) {

  if $plugin == 'webroot' and empty($webroot_paths) {
    fail("The 'webroot_paths' parameter must be specified when using the 'webroot' plugin")
  }

  if ($custom_plugin) {
    $command_start = "${letsencrypt_command} --text --agree-tos --non-interactive certonly "
  } else {
    $command_start = "${letsencrypt_command} --text --agree-tos --non-interactive certonly -a ${plugin} "
  }

  if $plugin == 'webroot' {
    $_command_domains = zip($domains, $webroot_paths).map |$domain| {
      if $domain[1] {
        "--webroot-path ${domain[1]} -d ${domain[0]}"
      } else {
        "-d ${domain[0]}"
      }
    }
    $command_domains = join([ "--cert-name ${title}", ] + $_command_domains, ' ')
  } else {
    $_command_domains = join($domains, ' -d ')
    $command_domains  = "--cert-name ${title} -d ${_command_domains}"
  }

  if empty($additional_args) {
    $command_end = undef
  } else {
    # ['',] adds an additional whitespace in the front
    $command_end = join(['',] + $additional_args, ' ')
  }

  $command = "${command_start}${command_domains}${command_end}"
  $live_path = "${config_dir}/live/${domains[0]}/cert.pem"

  $execution_environment = [ "VENV_PATH=${letsencrypt::venv_path}", ] + $environment
  $verify_domains = join($domains, ' -d ')
  exec { "letsencrypt certonly ${title}":
    command     => $command,
    path        => $::path,
    environment => $execution_environment,
    unless      => "test -f ${live_path} && ${letsencrypt_command} certificates --cert-name ${title} -d ${verify_domains} | grep -q 'Certificate Path'",
    require     => Class['letsencrypt'],
  }

  if $manage_cron {
    $maincommand = "${command_start}--keep-until-expiring ${command_domains}${command_end}"
    if $suppress_cron_output {
      $croncommand = "${maincommand} > /dev/null 2>&1"
    } else {
      $croncommand = $maincommand
    }
    if $cron_before_command {
      $renewcommand = "(${cron_before_command}) && ${croncommand}"
    } else {
      $renewcommand = $croncommand
    }
    if $cron_success_command {
      $cron_cmd = "${renewcommand} && (${cron_success_command})"
    } else {
      $cron_cmd = $renewcommand
    }
    file { "${::letsencrypt::cron_scripts_path}/renew-${title}.sh":
      ensure  => 'file',
      mode    => '0755',
      owner   => 'root',
      group   => $::letsencrypt::cron_owner_group,
      content => template('letsencrypt/renew-script.sh.erb'),
    }
    cron { "letsencrypt renew cron ${title}":
      command  => "${::letsencrypt::cron_scripts_path}/renew-${title}.sh",
      user     => root,
      hour     => $cron_hour,
      minute   => $cron_minute,
      monthday => $cron_monthday,
    }
  }
}
