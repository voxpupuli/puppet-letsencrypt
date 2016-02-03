# == Define: letsencrypt::client::ini
#
#   This configures a single setting in the LE INI file. This is a private resource.
#
define letsencrypt::config::ini () {

  assert_private()

  $name_split = split($name, '=')
  $setting = $name_split[0]
  $value = $name_split[1]
  $config_file = $::letsencrypt::config::config_file

  ini_setting { "${config_file} ${setting} ${value}":
    ensure  => present,
    path    => $config_file,
    section => '',
    setting => $setting,
    value   => $value,
    require => File['/etc/letsencrypt'],
  }

}
