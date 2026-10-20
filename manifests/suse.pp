# @summary SUSE-focused Certbot orchestration using the core letsencrypt module.
#
# This class keeps certificate lifecycle management in the module's native
# resources (install, config, renew, and hooks) and optionally prepares SUSE
# package sources via SUSEConnect/Packman.
#
# @param email Email used for ACME account registration.
# @param manage_suseconnect Whether SUSEConnect/Packman setup is managed.
# @param suseconnect_products SUSEConnect products/modules to enable.
# @param packman_repo Optional Packman repo URL.
# @param manage_install Whether certbot installation is managed.
# @param manage_config Whether certbot cli config is managed.
# @param package_ensure Desired package state for certbot.
# @param renew_cron_ensure Intended state of renewal cron.
# @param renew_disable_distro_cron Whether distro timer/cron should be disabled.
# @param renew_cron_hour Renewal cron hour.
# @param renew_cron_minute Renewal cron minute.
# @param renew_cron_monthday Renewal cron monthday.
# @param renew_cron_environment Optional renewal cron environment variables.
# @param renew_pre_hook_commands Commands run before renewal attempts.
# @param renew_post_hook_commands Commands run after renewal attempts.
# @param renew_deploy_hook_commands Commands run after successful renewal.
# @param enforce_sles_range Whether to enforce supported SLES 15.4-15.7 range.
#
class letsencrypt::suse (
  String[1] $email,
  Boolean $manage_suseconnect = false,
  Array[String[1]] $suseconnect_products = [],
  Optional[String[1]] $packman_repo = undef,
  Boolean $manage_install = true,
  Boolean $manage_config = true,
  String[1] $package_ensure = 'installed',
  Enum['present', 'absent'] $renew_cron_ensure = 'present',
  Boolean $renew_disable_distro_cron = true,
  Letsencrypt::Cron::Hour $renew_cron_hour = fqdn_rand(24),
  Letsencrypt::Cron::Minute $renew_cron_minute = fqdn_rand(60),
  Letsencrypt::Cron::Monthday $renew_cron_monthday = '*',
  Optional[Variant[String[1], Array[String[1]]]] $renew_cron_environment = undef,
  Variant[String[1], Array[String[1]]] $renew_pre_hook_commands = [],
  Variant[String[1], Array[String[1]]] $renew_post_hook_commands = [],
  Variant[String[1], Array[String[1]]] $renew_deploy_hook_commands = [],
  Boolean $enforce_sles_range = true,
) {
  if $facts['os']['name'] != 'SLES' {
    fail('letsencrypt::suse is only supported on SLES systems.')
  }

  if $enforce_sles_range {
    $sles_release = regsubst($facts['os']['release']['full'], '^([0-9]+\.[0-9]+).*$','\1')
    if versioncmp($sles_release, '15.4') < 0 or versioncmp($sles_release, '15.7') > 0 {
      fail("letsencrypt::suse currently supports SLES releases 15.4 through 15.7. Detected ${facts['os']['release']['full']}.")
    }
  }

  if $manage_suseconnect {
    class { 'letsencrypt::suseconnect':
      manage       => true,
      products     => $suseconnect_products,
      packman_repo => $packman_repo,
    }
  }

  class { 'letsencrypt':
    email                      => $email,
    manage_install             => $manage_install,
    manage_config              => $manage_config,
    package_ensure             => $package_ensure,
    renew_cron_ensure          => $renew_cron_ensure,
    renew_disable_distro_cron  => $renew_disable_distro_cron,
    renew_cron_hour            => $renew_cron_hour,
    renew_cron_minute          => $renew_cron_minute,
    renew_cron_monthday        => $renew_cron_monthday,
    renew_cron_environment     => $renew_cron_environment,
    renew_pre_hook_commands    => $renew_pre_hook_commands,
    renew_post_hook_commands   => $renew_post_hook_commands,
    renew_deploy_hook_commands => $renew_deploy_hook_commands,
  }

  if $manage_suseconnect {
    Class['letsencrypt::suseconnect'] -> Class['letsencrypt']
  }
}
