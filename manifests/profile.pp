# @summary Defines a Let's Encrypt profile.
# @param config A hash of configuration options for the profile.
# @param config_file Optional explicit path to the ini file. Defaults to `${config_dir}/${name}.ini`.
define letsencrypt::profile (
  Hash                 $config = {},
  Stdlib::Absolutepath $config_file = "${letsencrypt::config_dir}/${name}.ini",
) {
  include letsencrypt

  unless 'email' in $config {
    if 'register-unsafely-without-email' in $config {
      warning("Profile ${name}: No email address specified for the letsencrypt class! Registering unsafely!")
    } else {
      fail("Profile ${name}: Please specify an email address to register with Let's Encrypt")
    }
  }

  $config.each |$key,$value| {
    ini_setting { "${config_file} ${key} ${value}":
      ensure  => present,
      path    => $config_file,
      section => '',
      setting => $key,
      value   => $value,
      require => File[$letsencrypt::config_dir],
    }
  }
}
