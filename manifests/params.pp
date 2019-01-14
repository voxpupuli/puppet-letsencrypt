class letsencrypt::params {
  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_install      = true
  $manage_dependencies = true
  $package_ensure      = 'installed'
  $path                = '/opt/letsencrypt'
  $venv_path           = '/opt/letsencrypt/.venv' # virtualenv path for vcs-installed letsencrypt
  $repo                = 'https://github.com/certbot/certbot.git'
  $cron_scripts_path   = "${facts['puppet_vardir']}/letsencrypt" # path for renewal scripts called by cron
  $version             = 'v0.30.0'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }

  if $facts['operatingsystem'] == 'Debian' and versioncmp($facts['operatingsystemrelease'], '8') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $facts['operatingsystem'] == 'Ubuntu' and versioncmp($facts['operatingsystemrelease'], '16.04') == 0 {
    $install_method = 'package'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
    $config_dir = '/etc/letsencrypt'
  } elsif $facts['operatingsystem'] == 'Ubuntu' and versioncmp($facts['operatingsystemrelease'], '18.04') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $facts['osfamily'] == 'RedHat' and versioncmp($facts['operatingsystemmajrelease'], '7') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $facts['osfamily'] == 'Gentoo' {
    $install_method = 'package'
    $package_name = 'app-crypt/certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
} elsif $facts['osfamily'] == 'OpenBSD' {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
    $config_dir = '/etc/letsencrypt'
  } elsif $facts['osfamily'] == 'FreeBSD' {
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

  if $facts['osfamily'] == 'RedHat' {
    $configure_epel = true
  } else {
    $configure_epel = false
  }

  $cron_owner_group = $facts['osfamily'] ? {
    'OpenBSD' =>  'wheel',
    'FreeBSD' =>  'wheel',
    default   =>  'root',
  }
}
