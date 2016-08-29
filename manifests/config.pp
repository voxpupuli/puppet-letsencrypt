# == Class: certbot::config
#
#   This class configures the Let's Encrypt client. This is a private class.
#
class certbot::config (
  $config_file         = $certbot::config_file,
  $config              = $certbot::config,
  $email               = $certbot::email,
  $unsafe_registration = $certbot::unsafe_registration,
  $agree_tos           = $certbot::agree_tos,
) {

  assert_private()

  unless $agree_tos {
    fail("You must agree to the Let's Encrypt Terms of Service! See: https://letsencrypt.org/repository for more information." )
  }

  file {
    '/etc/letsencrypt' :
      ensure => directory;

    $config_file :
      ensure => file;
  }

  if $email {
    $_config = merge($config, {'email' => $email})
  } else {
    $_config = $config
  }

  unless 'email' in $_config {
    if $unsafe_registration {
      warning('No email address specified for the certbot class! Registering unsafely!')
      ini_setting { "${config_file} register-unsafely-without-email true":
        ensure  => present,
        path    => $config_file,
        section => '',
        setting => 'register-unsafely-without-email',
        value   => true,
        require => File['/etc/letsencrypt'],
      }
    } else {
      fail("Please specify an email address to register with Let's Encrypt using the \$email parameter on the certbot class")
    }
  }

  $_config_joined = { '' => $_config }

  $config_defaults_option = {
    path => $config_file,
  }

  create_ini_settings($_config_joined, $config_defaults_option)

}
