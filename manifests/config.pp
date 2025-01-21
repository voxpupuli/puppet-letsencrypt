# @summary Configures the Let's Encrypt client.
#
# @api private
#
class letsencrypt::config (
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Stdlib::Absolutepath $config_file = $letsencrypt::config_file,
  Hash $config = $letsencrypt::config,
  Optional[String[1]] $email = $letsencrypt::email,
  Boolean $unsafe_registration = $letsencrypt::unsafe_registration,
  Boolean $agree_tos = $letsencrypt::agree_tos,
) {
  assert_private()

  unless $agree_tos {
    fail("You must agree to the Let's Encrypt Terms of Service! See: https://letsencrypt.org/repository for more information." )
  }

  file { $config_dir: ensure => directory }

  file { $letsencrypt::cron_scripts_path:
    ensure => directory,
    purge  => true,
  }

  if $email {
    $_config = $config + { 'email' => $email }
  } else {
    $_config = $config
  }

  ini_setting { "${config_file} register-unsafely-without-email true":
    ensure  => bool2str($unsafe_registration, 'present', 'absent'),
    path    => $config_file,
    section => '',
    setting => 'register-unsafely-without-email',
    value   => true,
  }

  unless 'email' in $_config {
    if $unsafe_registration {
      warning('No email address specified for the letsencrypt class! Registering unsafely!')
    } else {
      fail("Please specify an email address to register with Let's Encrypt using the \$email parameter on the letsencrypt class")
    }
  }

  $_config.each |$key,$value| {
    ini_setting { "${config_file} ${key} ${value}":
      ensure  => present,
      path    => $config_file,
      section => '',
      setting => $key,
      value   => $value,
      require => File[$config_dir],
    }
  }
}
