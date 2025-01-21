# @summary Installs and configures the dns-gandi plugin
#
# This class installs and configures the Let's Encrypt dns-gandi plugin.
# https://pypi.org/project/certbot-plugin-gandi/
#
# @param api_key Gandi production api key secret. You can get it in you security tab of your account
# @param personnal_access_token Gandi personnal access token(PAT). You can get it in you security tab of your account
# @param package_name The name of the package to install when $manage_package is true.
# @param config_file The path to the configuration file.
# @param manage_package Manage the plugin package.
#
class letsencrypt::plugin::dns_gandi (
  String[1] $package_name,
  Optional[String[1]] $api_key                = undef,
  Optional[String[1]] $personnal_access_token = undef,
  Stdlib::Absolutepath $config_file           = "${letsencrypt::config_dir}/dns-gandi.ini",
  Boolean $manage_package                     = true,
) {
  require letsencrypt

  if $manage_package {
    package { $package_name:
      ensure => installed,
      before => File[$config_file],
    }
  }

  if $api_key != undef {
    $ini_vars = {
      'dns_gandi_api_key' => $api_key,
    }
  } elsif $personnal_access_token != undef {
    $ini_vars = {
      'dns_gandi_token' => $personnal_access_token,
    }
  } else {
    fail("expects a value for parameter 'api_key' or 'personnal_access_token'")
  }

  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
        vars => { '' => $ini_vars },
    }),
  }
}
