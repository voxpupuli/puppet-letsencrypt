# == Defined Type: letsencrypt::hook
#
#   This type is used by letsencrypt::renew and letsencrypt::certonly to create
#   hook scripts.
#
# === Parameters:
#
# [*type*]
#   Hook type. Can be pre, post or deploy.
# [*hook_file*]
#   Path to deploy hook script.
# [*commands*]
#   String or array of bash commands to execute when the hook is run by certbot.
#
define letsencrypt::hook (
  Enum['pre', 'post', 'deploy'] $type,
  String[1]                     $hook_file,
  # hook.sh.epp will validate this
  $commands,
) {

  $validate_env = $type ? {
    'deploy' => true,
    default  => false,
  }

  file { $hook_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp('letsencrypt/hook.sh.epp', {
      commands     => $commands,
      validate_env => $validate_env,
    }),
    # Defined in letsencrypt::config
    require => File['letsencrypt-renewal-hooks-puppet'],
  }

}
