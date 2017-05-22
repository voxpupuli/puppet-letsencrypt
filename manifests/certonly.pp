# == Defined Type: letsencrypt::certonly
#
#   This type can be used to request a certificate using the `certonly`
#   installer.
#
# === Parameters:
#
# [*domains*]
#   Namevar. An array of domains to include in the CSR.
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
#   If set, force cron's hour to this value. Must be between 0 and 23.
# [*cron_minute*]
#   If set, force cron's minute to this value. Must be between 0 and 59.
#
define letsencrypt::certonly (
  $domains              = [$title],
  $plugin               = 'standalone',
  $webroot_paths        = undef,
  $letsencrypt_command  = $letsencrypt::command,
  $additional_args      = undef,
  $environment          = [],
  $manage_cron          = false,
  $suppress_cron_output = false,
  $cron_before_command  = undef,
  $cron_success_command = undef,
  $cron_hour            = undef,
  $cron_minute          = undef
) {
  validate_array($domains)
  validate_re($plugin, ['^apache$', '^standalone$', '^webroot$'])
  if $webroot_paths {
    validate_array($webroot_paths)
  } elsif $plugin == 'webroot' {
    fail("The 'webroot_paths' parameter must be specified when using the 'webroot' plugin")
  }
  validate_string($letsencrypt_command)
  if $additional_args {
    validate_array($additional_args)
  }
  validate_array($environment)
  validate_bool($manage_cron)
  validate_bool($suppress_cron_output)
  if $cron_hour {
    validate_integer($cron_hour)
    if ($cron_hour < 0 or $cron_hour > 23) {
      fail("\$cron_hour must be set between 0 and 23, is ${cron_hour}")
    }
  }
  if $cron_minute {
    validate_integer($cron_minute)
    if ($cron_minute < 0 or $cron_minute > 59) {
      fail("\$cron_minute must be set between 0 and 59, is ${cron_minute}")
    }
  }

  $command_start = "${letsencrypt_command} --text --agree-tos certonly -a ${plugin} "
  $command_domains = $plugin ? {
    'webroot' => inline_template('<%= @domains.zip(@webroot_paths).map { |domain| "#{"--webroot-path #{domain[1]} " if domain[1]}-d #{domain[0]}"}.join(" ") %>'),
    default   => inline_template('-d <%= @domains.join(" -d ")%>'),
  }
  $command_end = inline_template('<% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $command = "${command_start}${command_domains}${command_end}"
  $live_path = inline_template('/etc/letsencrypt/live/<%= @domains.first %>/cert.pem')

  $venv_path_var = "VENV_PATH=${letsencrypt::venv_path}"
  exec { "letsencrypt certonly ${title}":
    command     => $command,
    path        => $::path,
    environment => concat([ $venv_path_var ], $environment),
    creates     => $live_path,
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
    $_cron_hour = $cron_hour ? {
      undef   => fqdn_rand(24, $title), # 0 - 23, seed is title plus fqdn
      default => $cron_hour
    }
    $_cron_minute = $cron_minute ? {
      undef   => fqdn_rand(60, $title), # 0 - 59, seed is title plus fqdn
      default => $cron_minute
    }
    file { "${::letsencrypt::cron_scripts_path}/renew-${title}.sh":
      ensure  => 'file',
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => "#!/bin/sh\n${cron_cmd}",
    }
    cron { "letsencrypt renew cron ${title}":
      command     => "${::letsencrypt::cron_scripts_path}/renew-${title}.sh",
      environment => concat([ $venv_path_var ], $environment),
      user        => root,
      hour        => $_cron_hour,
      minute      => $_cron_minute,
    }
  }
}
