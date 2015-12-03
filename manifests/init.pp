class letsencrypt (
  String             $path                = $letsencrypt::params::path,
  String             $repo                = $letsencrypt::params::repo,
  String             $version             = $letsencrypt::params::version,
  String             $config_file         = $letsencrypt::params::config_file,
  Hash[String, Any]  $config              = $letsencrypt::params::config,
  Boolean            $manage_config       = $letsencrypt::params::manage_config,
  Boolean            $manage_dependencies = $letsencrypt::params::manage_dependencies,
) inherits letsencrypt::params {

  if $manage_dependencies {
    $dependencies = ['python', 'git']
    package { $dependencies: }
    Package[$dependencies] -> Vcsrepo[$path]
  }

  if $manage_config {
    file { '/etc/letsencrypt': ensure => directory }
    $config.each |$setting, $value| {
      ini_setting { "${config_file} ${setting} ${value}":
        ensure  => present,
        path    => $config_file,
        section => '',
        setting => $setting,
        value   => $value,
        require => File['/etc/letsencrypt']
      }
    }
  }

  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => $repo,
    revision => $version,
    notify   => Exec['initialize letsencrypt'],
  }

  exec { 'initialize letsencrypt':
    command     => "${path}/letsencrypt-auto --agree-tos -h",
    refreshonly => true,
  }
}
