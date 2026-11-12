# @summary Configures the Let's Encrypt client.
#
# @api private
#
class letsencrypt::config (
  # TODO: as this is a private class, we can remove the parameters and define the variables in the class body.
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

  ensure_resource('file', $config_dir, { ensure => directory })

  $_config = $config + { 'email' => $email, 'register-unsafely-without-email' => $unsafe_registration }.filter |$k, $v| { $v }
  letsencrypt::profile { 'cli':
    config      => $_config,
    config_file => $config_file,
  }
}
