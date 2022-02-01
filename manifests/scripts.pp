# @summary Deploy helper scripts scripts
#
# @api private
#
class letsencrypt::scripts () {
  assert_private()

  # required in letsencrypt::certonly
  file { '/usr/local/sbin/letsencrypt-domain-validation':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0500',
    content => file("${module_name}/domain-validation.sh"),
  }
}
