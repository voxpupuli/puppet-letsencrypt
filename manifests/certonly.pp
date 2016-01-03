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
# [*letsencrypt_path*]
#   The path to the letsencrypt installation.
# [*additional_args*]
#   An array of additional command line arguments to pass to the
#   `letsencrypt-auto` command.
# [*manage_cron*]
#   Boolean indicating whether or not to schedule cron job for renewal, 
#   runs daily but only renews if near expiration e.g within 10 days. 
#
define letsencrypt::certonly (
  Array[String]                           $domains          = [$title],
  Enum['apache', 'standalone', 'webroot'] $plugin           = 'standalone',
  String                                  $letsencrypt_path = $letsencrypt::path,
  Optional[Array[String]]                 $additional_args  = undef,
  Boolean                                 $manage_cron      = false,
) {

  $command = inline_template('<%= @letsencrypt_path %>/letsencrypt-auto --agree-tos certonly -a <%= @plugin %> -d <%= @domains.join(" -d ")%><% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $live_path = inline_template('/etc/letsencrypt/live/<%= @domains.first %>/cert.pem')

  exec { "letsencrypt certonly ${title}":
    command => $command,
    path    => $::path,
    creates => $live_path,
    require => Class['letsencrypt'],
  }
  
  if $manage_cron {
    $renewcommand = inline_template('<%= @letsencrypt_path %>/letsencrypt-auto --agree-tos certonly -a <%= @plugin %> --keep-until-expiring -d <%= @domains.join(" -d ")%><% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
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
