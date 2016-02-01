class letsencrypt::params {
  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_install      = true
  $manage_dependencies = true
  $configure_epel      = false
  $config_file         = '/etc/letsencrypt/cli.ini'
  $path                = '/opt/letsencrypt'
  $repo                = 'git://github.com/letsencrypt/letsencrypt.git'
  $version             = 'v0.1.0'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }

  if $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '9') >= 0 {
    $install_method = 'package'
  } elsif $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '16.04') >= 0 {
    $install_method = 'package'
  } elsif $::osfamily == 'RedHat' {
    $install_method = 'package'
  } else {
    $install_method = 'vcs'
  }
}
