# @summary Request a certificate using the SUSE Podman certbot wrapper.
#
# This define keeps certificate issuance idempotent while leaving certbot
# execution inside the wrapper managed by letsencrypt::suse::podman.
#
# @param ensure Desired certificate state.
# @param domains Domains included in the certificate request.
# @param cert_name Certbot certificate name.
# @param additional_args Additional arguments passed to the wrapper.
#
define letsencrypt::suse::podman::certificate (
  Enum['present', 'absent'] $ensure = 'present',
  Array[String[1]] $domains = [$title],
  String[1] $cert_name = $domains[0],
  Array[String[1]] $additional_args = [],
) {
  $domain_args = $domains.map |String $domain| { "-d '${domain}'" }.join(' ')
  $additional_args_text = $additional_args.empty ? {
    true    => '',
    default => " ${additional_args.join(' ')}",
  }
  $wrapper = '/usr/local/lib/letsencrypt/certbot-podman.sh'
  $cert_path = "/etc/letsencrypt/live/${cert_name}/cert.pem"

  if $ensure == 'present' {
    $command = "${wrapper} certonly --dns-azure --cert-name '${cert_name}' ${domain_args}${additional_args_text}"
    $unless = "test -f '${cert_path}'"
    $onlyif = undef
  } else {
    $command = "${wrapper} delete --cert-name '${cert_name}' --non-interactive"
    $unless = undef
    $onlyif = "test -f '${cert_path}'"
  }

  exec { "letsencrypt-suse-podman-certificate-${title}":
    command => $command,
    unless  => $unless,
    onlyif  => $onlyif,
    path    => ['/usr/sbin', '/usr/bin', '/bin'],
    require => Class['letsencrypt::suse::podman'],
  }
}
