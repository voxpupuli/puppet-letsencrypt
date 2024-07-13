# @summary Deploy helper scripts scripts
#
# @api private
# @param root_group Group owner of renewal hooks and cron renew scripts.
#
class letsencrypt::scripts (
  String[1]                                 $root_group           = $letsencrypt::root_group,
) {
  assert_private()

  # required in letsencrypt::certonly
  file { '/usr/local/sbin/letsencrypt-domain-validation':
    ensure  => file,
    owner   => 'root',
    group   => $root_group,
    mode    => '0500',
    content => file("${module_name}/domain-validation.sh"),
  }
}
