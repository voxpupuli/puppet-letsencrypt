# == Class: letsencrypt::plugin::nginx
#
#   This class installs and configures the Let's Encrypt nginx plugin.
#
# === Parameters:
#
# [*manage_package*]
#   Manage the plugin package.
# [*package_name*]
#   The name of the package to install when $manage_package is true.
#
class letsencrypt::plugin::nginx (
  Boolean $manage_package          = $letsencrypt::nginx_manage_package,
  String $package_name             = $letsencrypt::nginx_package_name,
) {

  if $manage_package {
    package { $package_name:
      ensure          => installed,
      install_options => $operatingsystemmajrelease ? {
        '8'     => '--enablerepo=powertools',
        default => undef,
      },
    }

    file { '/etc/letsencrypt/options-ssl-nginx.conf':
      ensure  => link,
      target  => $::osfamily ? {
        'Redhat' => '/usr/lib/python3.6/site-packages/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf',
        'Debian' => '/usr/lib/python3/dist-packages/certbot_nginx/options-ssl-nginx.conf',
      },
      require => Package[$package_name],
    }
  }

}
