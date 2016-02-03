# == Class: letsencrypt
#
#   This class configures the Let's Encrypt client. This is a private class.
#
class letsencrypt::config (
  $config_file         = $letsencrypt::config_file,
  $config              = $letsencrypt::config,
  $email               = $letsencrypt::email,
  $unsafe_registration = $letsencrypt::unsafe_registration,
  $agree_tos           = $letsencrypt::agree_tos,
) {

  assert_private()

  unless $agree_tos {
    fail("You must agree to the Let's Encrypt Terms of Service! See: https://letsencrypt.org/repository for more information." )
  }

  file { '/etc/letsencrypt': ensure => directory }

  if $email {
    $_config = merge($config, {'email' => $email})
  } else {
    $_config = $config
  }

  unless 'email' in $_config {
    if $unsafe_registration {
      warning('No email address specified for the letsencrypt class! Registering unsafely!')
      ini_setting { "${config_file} register-unsafely-without-email true":
        ensure  => present,
        path    => $config_file,
        section => '',
        setting => 'register-unsafely-without-email',
        value   => true,
        require => File['/etc/letsencrypt'],
      }
    } else {
      fail("Please specify an email address to register with Let's Encrypt using the \$email parameter on the letsencrypt class")
    }
  }

  $_config_joined = join_keys_to_values($_config, '=')
  letsencrypt::config::ini { $_config_joined: }

}
