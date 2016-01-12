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
#   `webroot_paths` are not the same length, `webroot_paths`
#   will cycle to make up the difference.
# [*letsencrypt_path*]
#   The path to the letsencrypt installation.
# [*additional_args*]
#   An array of additional command line arguments to pass to the
#   `letsencrypt-auto` command.
# [*manage_cron*]
#   Boolean indicating whether or not to schedule cron job for renewal.
#   Runs daily but only renews if near expiration, e.g. within 10 days. 
#
define letsencrypt::certonly (
  Array[String]                           $domains          = [$title],
  Enum['apache', 'standalone', 'webroot'] $plugin           = 'standalone',
  Optional[Array[String]]                 $webroot_paths    = undef,
  String                                  $letsencrypt_path = $letsencrypt::path,
  Optional[Array[String]]                 $additional_args  = undef,
  Boolean                                 $manage_cron      = false,
) {

  $command_start = "${letsencrypt_path}/letsencrypt-auto --agree-tos certonly -a ${plugin} "
  $command_domains = $plugin ? {
    'webroot' => inline_template('<%= @domains.zip(@webroot_paths.cycle).map { |domain| "--webroot-path #{domain[1]} -d #{domain[0]}"}.join(" ") %>'),
    default   => inline_template('-d <%= @domains.join(" -d ")%>'),
  }
  $command_end = inline_template('<% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $command = "${command_start}${command_domains}${command_end}"
  $live_path = inline_template('/etc/letsencrypt/live/<%= @domains.first %>/cert.pem')

  exec { "letsencrypt certonly ${title}":
    command => $command,
    path    => $::path,
    creates => $live_path,
    require => Class['letsencrypt'],
  }
  
  if $manage_cron {
    $renewcommand = "${command_start}--keep-until-expiring ${command_domains}${command_end}"
    $cron_hour = fqdn_rand(24, $title) # 0 - 23, seed is title plus fqdn
    $cron_minute = fqdn_rand(60, $title ) # 0 - 59, seed is title plus fqdn
    cron { "letsencrypt renew cron ${title}":
      command => $renewcommand,
      user    => root,
      hour    => $cron_hour,
      minute  => $cron_minute,
    }
  }
}
