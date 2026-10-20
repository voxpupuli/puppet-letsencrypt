# @summary Manage SUSE channel access for certbot package sources.
#
# This class is intentionally SUSE-only. It can be used to
# enable required SUSE channels via SUSEConnect and to add a Packman repo.
#
# @param manage Whether channel/repo commands should be enforced.
# @param products Array of SUSEConnect product/module identifiers to enable.
# @param packman_repo Optional Packman repository URL.
# @param suseconnect_command Path to SUSEConnect executable.
# @param zypper_command Path to zypper executable.
# @param state_dir Path used for local SUSEConnect state markers.
# @param enforce_sles_range Whether to enforce supported SLES 15.4-15.7 range.
#
class letsencrypt::suseconnect (
  Boolean $manage                             = false,
  Array[String[1]] $products                  = [],
  Optional[String[1]] $packman_repo           = undef,
  Stdlib::Absolutepath $suseconnect_command   = '/usr/sbin/SUSEConnect',
  Stdlib::Absolutepath $zypper_command        = '/usr/bin/zypper',
  Stdlib::Absolutepath $state_dir             = '/var/lib/letsencrypt/suseconnect',
  Boolean $enforce_sles_range                 = true,
) {
  if $facts['os']['name'] != 'SLES' {
    fail('letsencrypt::suseconnect is only supported on SLES systems.')
  }

  if $enforce_sles_range {
    $sles_release = regsubst($facts['os']['release']['full'], '^([0-9]+\.[0-9]+).*$','\1')
    if versioncmp($sles_release, '15.4') < 0 or versioncmp($sles_release, '15.7') > 0 {
      fail("letsencrypt::suseconnect currently supports SLES releases 15.4 through 15.7. Detected ${facts['os']['release']['full']}.")
    }
  }

  if $manage and empty($products) and $packman_repo == undef {
    fail('Set at least one SUSEConnect product or a Packman repo when manage => true.')
  }

  if $manage {
    file { $state_dir:
      ensure => directory,
      owner  => 'root',
      group  => 0,
      mode   => '0755',
    }

    $product_exec_refs = $products.map |String[1] $product| {
      $product_tag = regsubst($product, '[^0-9A-Za-z._-]', '_', 'G')
      $product_state_file = "${state_dir}/${product_tag}.enabled"

      exec { "letsencrypt-suseconnect-${product}":
        command => "/bin/sh -c \"${suseconnect_command} -p ${product} && touch ${product_state_file}\"",
        # lint:ignore:140chars
        unless  => "/bin/sh -c \"test -f ${product_state_file} && (${suseconnect_command} --status 2>/dev/null | grep -F -- '${product}' >/dev/null || ${suseconnect_command} --status-text 2>/dev/null | grep -F -- '${product}' >/dev/null)\"",
        # lint:endignore
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => File[$state_dir],
      }

      "Exec[letsencrypt-suseconnect-${product}]"
    }

    if $packman_repo != undef {
      exec { 'letsencrypt-add-packman-repo':
        command => "${zypper_command} --non-interactive ar -f ${packman_repo} packman",
        unless  => "${zypper_command} --non-interactive lr --uri | grep -F -- \"${packman_repo}\"",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => [File[$state_dir]] + $product_exec_refs,
      }
    }
  }
}
