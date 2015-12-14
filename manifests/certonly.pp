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
#
define letsencrypt::certonly (
  Array[String]                           $domains          = [$title],
  Enum['apache', 'standalone', 'webroot'] $plugin           = 'standalone',
  String                                  $letsencrypt_path = $letsencrypt::path,
  Optional[Array[String]]                 $additional_args  = undef,
) {

  $command = inline_template('<%= @letsencrypt_path %>/letsencrypt-auto certonly -a <%= @plugin %> -d <%= @domains.join(" -d ")%><% if @additional_args %> <%= @additional_args.join(" ") %><%end%>')
  $live_path = inline_template('/etc/letsencrypt/live/<%= @domains.first %>/cert.pem')

  exec { "letsencrypt certonly ${title}":
    command => $command,
    path    => $::path,
    creates => $live_path,
    require => Class['letsencrypt'],
  }
}
