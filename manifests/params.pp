class letsencrypt::params {

  unless ($::osfamily == 'Debian') or ($::osfamily == 'RedHat') {
    fail("The letsencrypt module does not support ${::osfamily}-based operating systems at this time.")
  }

  $agree_tos           = true
  $unsafe_registration = false
  $manage_config       = true
  $manage_dependencies = true
  $config_file         = '/etc/letsencrypt/cli.ini'
  $path                = '/opt/letsencrypt'
  $repo                = 'git://github.com/letsencrypt/letsencrypt.git'
  $version             = 'v0.1.0'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory',
  }
  $manage_cron         = false
}
