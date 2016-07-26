# == Defined Type: certbot::certonly
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
# [*certbot_command*]
#   Command to run certbot
# [*additional_args*]
#   An array of additional command line arguments to pass to the
#   `certbot-auto` command.
# [*environment*]
#   An optional array of environment variables (in addition to VENV_PATH).
# [*manage_cron*]
#   Boolean indicating whether or not to schedule cron job for renewal.
#   Runs daily but only renews if near expiration, e.g. within 10 days.
# [*cron_success_command*]
#   String representation of a command that should be run if the renewal command
#   succeeds.
#
define certbot::certonly (
  $domains              = [$title],
  $plugin               = 'standalone',
  $webroot_paths        = undef,
  $certbot_command      = $certbot::command,
  $additional_args      = undef,
  $environment          = [],
  $manage_cron          = false,
  $cron_success_command = undef,
) {
  validate_array($domains)
  validate_re($plugin, ['^apache$', '^standalone$', '^webroot$'])
  if $webroot_paths {
    validate_array($webroot_paths)
  } elsif $plugin == 'webroot' {
    fail("The 'webroot_paths' parameter must be specified when using the 'webroot' plugin")
  }
  validate_string($certbot_command)
  if $additional_args {
    validate_array($additional_args)
  }
  validate_array($environment)
  validate_bool($manage_cron)

  $command_start = "${certbot_command} --agree-tos certonly -a ${plugin} "
  $command_domains = $plugin ? {
    'webroot' => inline_template('<%= @domains.zip(@webroot_paths).map { |domain| "#{"--webroot-path #{domain[1]} " if domain[1]}-d #{domain[0]}"}.join(" ") %>'),
    default   => inline_template('-d <%= @domains.join(" -d ")%>'),
  }
  $command_end = inline_template('<% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $command = "${command_start}${command_domains}${command_end}"
  $live_path = inline_template('/etc/letsencrypt/live/<%= @domains.first %>/cert.pem')

  $venv_path_var = "VENV_PATH=${certbot::venv_path}"
  exec { "certbot certonly ${title}":
    command     => $command,
    path        => $::path,
    environment => concat([ $venv_path_var ], $environment),
    creates     => $live_path,
    require     => Class['certbot'],
  }

  if $manage_cron {
    $renewcommand = "${command_start}--keep-until-expiring --quiet ${command_domains}${command_end}"

    if $cron_success_command {
      $cron_cmd = "${renewcommand} && (${cron_success_command})"
    } else {
      $cron_cmd = $renewcommand
    }
    $cron_hour = fqdn_rand(24, $title) # 0 - 23, seed is title plus fqdn
    $cron_minute = fqdn_rand(60, $title ) # 0 - 59, seed is title plus fqdn
    cron { "certbot renew cron ${title}":
      command     => $cron_cmd,
      environment => concat([ $venv_path_var ], $environment),
      user        => root,
      hour        => $cron_hour,
      minute      => $cron_minute,
    }
  }
}
