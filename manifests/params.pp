class letsencrypt::params {

  unless ($::osfamily == 'Debian') or ($::osfamily == 'RedHat') {
    fail("The letsencrypt module does not support ${::osfamily}-based operating systems at this time.")
  }

  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_install      = true
  $manage_dependencies = true
  $config_file         = '/etc/letsencrypt/cli.ini'
  $path                = '/opt/letsencrypt'
  $repo                = 'git://github.com/letsencrypt/letsencrypt.git'
  $version             = 'v0.1.0'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }

  case $::osfamily {
    'Debian': {
      case $::operatingsystem {
        'Debian': {
          if versioncmp($::operatingsystemrelease, '9') >= 0 {
            $install_method = 'package'
          } else {
            $install_method = 'vcs'
          }
        }
        'Ubuntu': {
          if versioncmp($::operatingsystemrelease, '16.04') >= 0 {
            $install_method = 'package'
          } else {
            $install_method = 'vcs'
          }
        }
        default: {
          $install_method = 'vcs'
        }
      }
    }
    'RedHat': {
      $install_method = 'package'
    }
  }
}
