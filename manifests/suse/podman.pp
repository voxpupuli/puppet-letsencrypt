# @summary Manage certbot in a Podman container on SUSE.
#
# This class provides containerized certbot execution via Podman, keeping
# the container runtime separate from native host packages. It is designed
# as an alternative to letsencrypt::suse for scenarios where container
# isolation is preferred or native certbot packages are unavailable.
#
# @param email Email used for ACME account registration.
# @param container_image Container image URI for certbot (default: certbot/certbot).
# @param container_tag Container image tag (default: latest).
# @param manage_podman Whether to install and enable podman.
# @param manage_config Whether to manage certbot cli config inside the container.
# @param renew_cron_ensure Intended state of renewal cron.
# @param renew_cron_hour Renewal cron hour.
# @param renew_cron_minute Renewal cron minute.
# @param renew_cron_monthday Renewal cron monthday.
# @param renew_cron_environment Optional renewal cron environment variables.
# @param renew_pre_hook_commands Commands run before renewal attempts.
# @param renew_post_hook_commands Commands run after renewal attempts.
# @param renew_deploy_hook_commands Commands run after successful renewal.
# @param azure_config_file Path to Azure plugin config file on host.
# @param manage_azure_config Whether to manage the Azure plugin config file.
# @param azure_config_content Azure plugin config file content (INI format).
# @param letsencrypt_dir Host path for /etc/letsencrypt persistence.
# @param certbot_wrapper_dir Directory for certbot wrapper scripts.
# @param enforce_sles_range Whether to enforce supported SLES 15.4-15.7 range.
#
class letsencrypt::suse::podman (
  String[1] $email,
  String[1] $container_image = 'certbot/certbot',
  String[1] $container_tag = 'latest',
  Boolean $manage_podman = true,
  Boolean $manage_config = true,
  Enum['present', 'absent'] $renew_cron_ensure = 'present',
  Letsencrypt::Cron::Hour $renew_cron_hour = fqdn_rand(24),
  Letsencrypt::Cron::Minute $renew_cron_minute = fqdn_rand(60),
  Letsencrypt::Cron::Monthday $renew_cron_monthday = '*',
  Optional[Variant[String[1], Array[String[1]]]] $renew_cron_environment = undef,
  Variant[String[1], Array[String[1]]] $renew_pre_hook_commands = [],
  Variant[String[1], Array[String[1]]] $renew_post_hook_commands = [],
  Variant[String[1], Array[String[1]]] $renew_deploy_hook_commands = [],
  Stdlib::Absolutepath $azure_config_file = '/etc/letsencrypt/azure.ini',
  Boolean $manage_azure_config = false,
  Optional[String[1]] $azure_config_content = undef,
  Stdlib::Absolutepath $letsencrypt_dir = '/etc/letsencrypt',
  Stdlib::Absolutepath $certbot_wrapper_dir = '/usr/local/lib/letsencrypt',
  Boolean $enforce_sles_range = true,
) {
  if $facts['os']['name'] != 'SLES' {
    fail('letsencrypt::suse::podman is only supported on SLES systems.')
  }

  if $enforce_sles_range {
    $sles_release = regsubst($facts['os']['release']['full'], '^([0-9]+\.[0-9]+).*$','\1')
    if versioncmp($sles_release, '15.4') < 0 or versioncmp($sles_release, '15.7') > 0 {
      fail(
        'letsencrypt::suse::podman currently supports SLES releases 15.4 through 15.7. ' +
        "Detected ${facts['os']['release']['full']}.",
      )
    }
  }

  if $manage_podman {
    package { 'podman':
      ensure => 'installed',
    }

    service { 'podman':
      ensure => 'running',
      enable => true,
    }
  }

  # Create wrapper directory for certbot scripts
  file { $certbot_wrapper_dir:
    ensure => directory,
    owner  => 'root',
    group  => 0,
    mode   => '0755',
  }

  # Create /etc/letsencrypt with proper permissions
  file { $letsencrypt_dir:
    ensure => directory,
    owner  => 'root',
    group  => 0,
    mode   => '0755',
  }

  # Manage Azure plugin config if requested
  if $manage_azure_config and $azure_config_content != undef {
    file { $azure_config_file:
      ensure  => file,
      owner   => 'root',
      group   => 0,
      mode    => '0600',
      content => $azure_config_content,
      require => File[$letsencrypt_dir],
    }
  }

  # Create certbot wrapper script for convenient invocation
  file { "${certbot_wrapper_dir}/certbot-podman.sh":
    ensure  => file,
    owner   => 'root',
    group   => 0,
    mode    => '0755',
    content => epp('letsencrypt/suse/certbot-podman.sh.epp', {
      container_image     => $container_image,
      container_tag       => $container_tag,
      letsencrypt_dir     => $letsencrypt_dir,
      azure_config_file   => $azure_config_file,
      manage_azure_config => $manage_azure_config,
    }),
    require => [File[$certbot_wrapper_dir], File[$letsencrypt_dir]],
  }

  # Create certbot renewal cron job
  if $renew_cron_ensure == 'present' {
    cron { 'letsencrypt-suse-podman-renew':
      ensure      => present,
      command     => "${certbot_wrapper_dir}/certbot-podman.sh renew -q",
      hour        => $renew_cron_hour,
      minute      => $renew_cron_minute,
      monthday    => $renew_cron_monthday,
      environment => $renew_cron_environment,
      require     => File["${certbot_wrapper_dir}/certbot-podman.sh"],
    }
  } else {
    cron { 'letsencrypt-suse-podman-renew':
      ensure => absent,
    }
  }
}
