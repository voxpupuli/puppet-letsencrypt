class letsencrypt::params {

  unless $::osfamily == 'Debian' {
    fail('The letsencrypt module only supports Debian-based operating systems at this time.')
  }

  $manage_config       = true
  $manage_dependencies = true
  $config_file         = '/etc/letsencrypt/cli.ini'
  $path                = '/opt/letsencrypt'
  $repo                = 'git://github.com/letsencrypt/letsencrypt.git'
  $version             = 'v0.1.0'
  $config              = {
    'server' => 'https://acme-v01.api.letsencrypt.org/directory'
  }
}
