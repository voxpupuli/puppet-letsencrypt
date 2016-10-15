class letsencrypt::params {
  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_install      = true
  $manage_dependencies = true
  $package_ensure      = 'installed'
  $path                = '/opt/letsencrypt'
  $venv_path           = '/opt/letsencrypt/.venv' # virtualenv path for vcs-installed letsencrypt
  $repo                = 'https://github.com/letsencrypt/letsencrypt.git'
  $cron_scripts_path   = "${::puppet_vardir}/letsencrypt" # path for renewal scripts called by cron
  $version             = 'v0.9.3'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }

  if $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '16.04') >= 0 {
    $install_method = 'package'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
    $config_dir = '/etc/letsencrypt'
  } elsif $::osfamily == 'RedHat' and versioncmp($::operatingsystemmajrelease, '7') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $::osfamily == 'Gentoo' {
    $install_method = 'package'
    $package_name = 'app-crypt/certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
} elsif $::osfamily == 'OpenBSD' {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $::osfamily == 'FreeBSD' {
    $install_method = 'package'
    $package_name = 'py27-certbot'
    $package_command = 'certbot'
    $config_dir = '/usr/local/etc/letsencrypt'
  } else {
    $install_method = 'vcs'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
    $config_dir = '/etc/letsencrypt'
  }

  $config_file = "${config_dir}/cli.ini"

  if $::osfamily == 'RedHat' {
    $configure_epel = true
  } else {
    $configure_epel = false
  }

  $cron_owner_group = $::osfamily ? {
    'OpenBSD' =>  'wheel',
    default   =>  'root',
  }
}
