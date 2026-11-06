# @summary Request certificates on SUSE with Puppet-managed certbot behavior.
#
# This define keeps certificate issuance in letsencrypt::certonly while
# configuring the selected ACME challenge type.
#
# @param domains Domains for the certificate request.
# @param cert_name Certificate common name used by certbot.
# @param plugin ACME challenge type to use for the certificate request.
# @param azure_config_file Path to certbot dns-azure plugin config file.
# @param webroot_paths Webroot paths for domains when using HTTP-01.
# @param additional_args Additional certbot arguments appended to plugin args.
# @param environment Optional environment variables for certonly.
# @param manage_cron Whether to create a per-certificate renewal cron.
# @param cron_output Per-certificate cron output mode.
# @param cron_before_command Command to run before per-cert renewal command.
# @param cron_success_command Command to run after successful renewal command.
# @param cron_monthday Per-certificate cron monthday.
# @param cron_hour Per-certificate cron hour.
# @param cron_minute Per-certificate cron minute.
# @param pre_hook_commands Certonly pre-hook commands.
# @param post_hook_commands Certonly post-hook commands.
# @param deploy_hook_commands Certonly deploy-hook commands.
# @param validate_azure_config Whether to pre-validate azure config readability.
# @param enforce_sles_range Whether to enforce supported SLES 15.4-15.7 range.
#
define letsencrypt::suse::certificate (
  Array[String[1]] $domains = [$title],
  String[1] $cert_name = $domains[0],
  Enum['dns-01', 'http-01'] $plugin = 'dns-01',
  Stdlib::Absolutepath $azure_config_file = '/etc/letsencrypt/azure.ini',
  Array[Stdlib::Unixpath] $webroot_paths = [],
  Array[String[1]] $additional_args = [],
  Array[String[1]] $environment = [],
  Boolean $manage_cron = false,
  Optional[Enum['suppress', 'log']] $cron_output = undef,
  Optional[String[1]] $cron_before_command = undef,
  Optional[String[1]] $cron_success_command = undef,
  Array[Variant[Integer[1, 31], String[1]]] $cron_monthday = ['*'],
  Variant[Integer[0, 23], String, Array] $cron_hour = [fqdn_rand(12, $title), fqdn_rand(12, $title) + 12],
  Variant[Integer[0, 59], String, Array] $cron_minute = fqdn_rand(60, $title),
  Variant[String[1], Array[String[1]]] $pre_hook_commands = [],
  Variant[String[1], Array[String[1]]] $post_hook_commands = [],
  Variant[String[1], Array[String[1]]] $deploy_hook_commands = [],
  Boolean $validate_azure_config = true,
  Boolean $enforce_sles_range = true,
) {
  if $facts['os']['name'] != 'SLES' {
    fail('letsencrypt::suse::certificate is only supported on SLES systems.')
  }

  if $enforce_sles_range {
    $sles_release = regsubst($facts['os']['release']['full'], '^([0-9]+\.[0-9]+).*$','\1')
    if versioncmp($sles_release, '15.4') < 0 or versioncmp($sles_release, '15.7') > 0 {
      fail(
        'letsencrypt::suse::certificate currently supports SLES releases 15.4 through 15.7. ' +
        "Detected ${facts['os']['release']['full']}.",
      )
    }
  }

  if $plugin == 'dns-01' {
    class { 'letsencrypt::plugin::dns_azure':
      config_path => $azure_config_file,
    }

    if $validate_azure_config {
      exec { "letsencrypt-suse-certificate-preflight-${title}":
        # lint:ignore:140chars
        command => "/bin/sh -c 'echo \"dns-azure config file is not readable for ${title}. Verify ${azure_config_file} exists and is readable by root.\" 1>&2; exit 1'",
        # lint:endignore
        unless  => "/bin/sh -c 'test -r ${azure_config_file}'",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => Class['letsencrypt::plugin::dns_azure'],
      }
    }

    $certonly_requires = $validate_azure_config ? {
      true    => [Class['letsencrypt::plugin::dns_azure'], Exec["letsencrypt-suse-certificate-preflight-${title}"]],
      default => [Class['letsencrypt::plugin::dns_azure']],
    }
    $certonly_plugin = 'dns-azure'
  } else {
    $certonly_requires = []
    $certonly_plugin = 'webroot'
  }

  letsencrypt::certonly { $title:
    domains              => $domains,
    cert_name            => $cert_name,
    plugin               => $certonly_plugin,
    webroot_paths        => $webroot_paths,
    additional_args      => $additional_args,
    environment          => $environment,
    manage_cron          => $manage_cron,
    cron_output          => $cron_output,
    cron_before_command  => $cron_before_command,
    cron_success_command => $cron_success_command,
    cron_monthday        => $cron_monthday,
    cron_hour            => $cron_hour,
    cron_minute          => $cron_minute,
    pre_hook_commands    => $pre_hook_commands,
    post_hook_commands   => $post_hook_commands,
    deploy_hook_commands => $deploy_hook_commands,
    require              => $certonly_requires,
  }
}
