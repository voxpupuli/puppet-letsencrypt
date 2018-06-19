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
#
define letsencrypt::certonly (
  Array $domains                                            = [$title],
  Boolean $custom_plugin                                    = false,
  Enum['apache', 'standalone', 'webroot', 'nginx', 'dns-route53'] $plugin  = 'standalone',
  Optional[Array] $webroot_paths                            = undef,
  String $letsencrypt_command                               = $letsencrypt::command,
  Optional[Array] $additional_args                          = undef,
  Array $environment                                        = [],
  Boolean $manage_cron                                      = false,
  Boolean $suppress_cron_output                             = false,
  $cron_before_command                                      = undef,
  $cron_success_command                                     = undef,
  Stdlib::Unixpath $config_dir                              = $letsencrypt::config_dir,
) {

  if $plugin == 'webroot' {
    unless $webroot_paths {
      fail("The 'webroot_paths' parameter must be specified when using the 'webroot' plugin")
    }
  }

  if ($custom_plugin) {
    $command_start = "${letsencrypt_command} --text --agree-tos --non-interactive certonly "
  } else {
    $command_start = "${letsencrypt_command} --text --agree-tos --non-interactive certonly -a ${plugin} "
  }

  $command_domains = $plugin ? {
    'webroot' => inline_template('<%= @domains.zip(@webroot_paths).map { |domain| "#{"--webroot-path #{domain[1]} " if domain[1]}-d #{domain[0]}"}.join(" ") %>'),
    default   => inline_template('-d <%= @domains.join(" -d ")%>'),
  }
  $command_end = inline_template('<% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $command = "${command_start}${command_domains}${command_end}"
  $live_path = inline_template("${config_dir}/live/<%= @domains.first %>/cert.pem")

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
    $cron_hour = fqdn_rand(24, $title) # 0 - 23, seed is title plus fqdn
    $cron_minute = fqdn_rand(60, fqdn_rand_string(10,$title)) # 0 - 59, seed is title plus fqdn
    file { "${::letsencrypt::cron_scripts_path}/renew-${title}.sh":
      ensure  => 'file',
      mode    => '0755',
      owner   => 'root',
      group   => $::letsencrypt::cron_owner_group,
      content => "#!/bin/sh\n${cron_cmd}",
    }
    cron { "letsencrypt renew cron ${title}":
      command     => "${::letsencrypt::cron_scripts_path}/renew-${title}.sh",
      environment => concat([ $venv_path_var ], $environment),
      user        => root,
      hour        => $cron_hour,
      minute      => $cron_minute,
    }
  }
}
