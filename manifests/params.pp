class letsencrypt::params {
  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_install      = true
  $manage_dependencies = true
  $package_ensure      = 'installed'
  $config_file         = '/etc/letsencrypt/cli.ini'
  $path                = '/opt/letsencrypt'
  $venv_path           = '/opt/letsencrypt/.venv' # virtualenv path for vcs-installed letsencrypt
  $repo                = 'https://github.com/letsencrypt/letsencrypt.git'
  $version             = 'v0.9.3'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }

  if $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '9') >= 0 {
    $install_method = 'package'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
  } elsif $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '16.04') >= 0 {
    $install_method = 'package'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
  } elsif $::osfamily == 'RedHat' and versioncmp($::operatingsystemmajrelease, '7') >= 0 {
    $install_method = 'package'
    $package_name = 'certbot'
    $package_command = 'certbot'
  } elsif $::osfamily == 'Gentoo' {
    $install_method = 'package'
    $package_name = 'app-crypt/certbot'
    $package_command = 'certbot'
  } else {
    $install_method = 'vcs'
    $package_name = 'letsencrypt'
    $package_command = 'letsencrypt'
  }

  if $::osfamily == 'RedHat' {
    $configure_epel = true
  } else {
    $configure_epel = false
  }
}
