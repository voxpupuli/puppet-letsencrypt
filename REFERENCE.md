# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`letsencrypt`](#letsencrypt): Install and configure Certbot, the LetsEncrypt client
* [`letsencrypt::plugin::dns_cloudflare`](#letsencrypt--plugin--dns_cloudflare): Installs and configures the dns-cloudflare plugin
* [`letsencrypt::plugin::dns_linode`](#letsencrypt--plugin--dns_linode): Installs and configures the dns-linode plugin
* [`letsencrypt::plugin::dns_rfc2136`](#letsencrypt--plugin--dns_rfc2136): Installs and configures the dns-rfc2136 plugin
* [`letsencrypt::plugin::dns_route53`](#letsencrypt--plugin--dns_route53): Installs and configures the dns-route53 plugin
* [`letsencrypt::plugin::nginx`](#letsencrypt--plugin--nginx): install and configure the Let's Encrypt nginx plugin
* [`letsencrypt::renew`](#letsencrypt--renew): Configures renewal of Let's Encrypt certificates using Certbot

#### Private Classes

* `letsencrypt::config`: Configures the Let's Encrypt client.
* `letsencrypt::install`: Installs the Let's Encrypt client.
* `letsencrypt::scripts`: Deploy helper scripts scripts

### Defined types

* [`letsencrypt::certonly`](#letsencrypt--certonly): Request a certificate using the `certonly` installer
* [`letsencrypt::hook`](#letsencrypt--hook): Creates hook scripts.

### Functions

* [`letsencrypt::letsencrypt_lookup`](#letsencrypt--letsencrypt_lookup)

### Data types

* [`Letsencrypt::Cron::Hour`](#Letsencrypt--Cron--Hour): mimic hour setting in cron as defined in man 5 crontab
* [`Letsencrypt::Cron::Minute`](#Letsencrypt--Cron--Minute): mimic minute setting in cron as defined in man 5 crontab
* [`Letsencrypt::Cron::Monthday`](#Letsencrypt--Cron--Monthday): mimic monthday setting in cron as defined in man 5 crontab
* [`Letsencrypt::Plugin`](#Letsencrypt--Plugin): List of accepted plugins

## Classes

### <a name="letsencrypt"></a>`letsencrypt`

Install and configure Certbot, the LetsEncrypt client

#### Examples

##### 

```puppet
class { 'letsencrypt' :
  email  => 'letsregister@example.com',
  config => {
    'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
  },
}
```

#### Parameters

The following parameters are available in the `letsencrypt` class:

* [`email`](#-letsencrypt--email)
* [`environment`](#-letsencrypt--environment)
* [`package_name`](#-letsencrypt--package_name)
* [`package_ensure`](#-letsencrypt--package_ensure)
* [`package_command`](#-letsencrypt--package_command)
* [`config_file`](#-letsencrypt--config_file)
* [`config`](#-letsencrypt--config)
* [`cron_scripts_path`](#-letsencrypt--cron_scripts_path)
* [`cron_owner_group`](#-letsencrypt--cron_owner_group)
* [`manage_config`](#-letsencrypt--manage_config)
* [`manage_install`](#-letsencrypt--manage_install)
* [`configure_epel`](#-letsencrypt--configure_epel)
* [`agree_tos`](#-letsencrypt--agree_tos)
* [`unsafe_registration`](#-letsencrypt--unsafe_registration)
* [`config_dir`](#-letsencrypt--config_dir)
* [`key_size`](#-letsencrypt--key_size)
* [`certificates`](#-letsencrypt--certificates)
* [`renew_pre_hook_commands`](#-letsencrypt--renew_pre_hook_commands)
* [`renew_post_hook_commands`](#-letsencrypt--renew_post_hook_commands)
* [`renew_deploy_hook_commands`](#-letsencrypt--renew_deploy_hook_commands)
* [`renew_additional_args`](#-letsencrypt--renew_additional_args)
* [`renew_disable_distro_cron`](#-letsencrypt--renew_disable_distro_cron)
* [`renew_cron_ensure`](#-letsencrypt--renew_cron_ensure)
* [`renew_cron_hour`](#-letsencrypt--renew_cron_hour)
* [`renew_cron_minute`](#-letsencrypt--renew_cron_minute)
* [`renew_cron_monthday`](#-letsencrypt--renew_cron_monthday)
* [`renew_cron_environment`](#-letsencrypt--renew_cron_environment)
* [`certonly_pre_hook_commands`](#-letsencrypt--certonly_pre_hook_commands)
* [`certonly_post_hook_commands`](#-letsencrypt--certonly_post_hook_commands)
* [`certonly_deploy_hook_commands`](#-letsencrypt--certonly_deploy_hook_commands)

##### <a name="-letsencrypt--email"></a>`email`

Data type: `Optional[String]`

The email address to use to register with Let's Encrypt. This takes
precedence over an 'email' setting defined in $config.

Default value: `undef`

##### <a name="-letsencrypt--environment"></a>`environment`

Data type: `Array`

An optional array of environment variables

Default value: `[]`

##### <a name="-letsencrypt--package_name"></a>`package_name`

Data type: `String`

Name of package and command to use when installing the client package.

Default value: `'certbot'`

##### <a name="-letsencrypt--package_ensure"></a>`package_ensure`

Data type: `String[1]`

The value passed to `ensure` when installing the client package.

Default value: `'installed'`

##### <a name="-letsencrypt--package_command"></a>`package_command`

Data type: `String`

Path or name for letsencrypt executable.

Default value: `'certbot'`

##### <a name="-letsencrypt--config_file"></a>`config_file`

Data type: `String`

The path to the configuration file for the letsencrypt cli.

Default value: `"${config_dir}/cli.ini"`

##### <a name="-letsencrypt--config"></a>`config`

Data type: `Hash`

A hash representation of the letsencrypt configuration file.

Default value: `{ 'server' => 'https://acme-v02.api.letsencrypt.org/directory' }`

##### <a name="-letsencrypt--cron_scripts_path"></a>`cron_scripts_path`

Data type: `String`

The path for renewal scripts called by cron

Default value: `"${facts['puppet_vardir']}/letsencrypt"`

##### <a name="-letsencrypt--cron_owner_group"></a>`cron_owner_group`

Data type: `String`

Group owner of cron renew scripts.

Default value: `'root'`

##### <a name="-letsencrypt--manage_config"></a>`manage_config`

Data type: `Boolean`

A feature flag to toggle the management of the letsencrypt configuration file.

Default value: `true`

##### <a name="-letsencrypt--manage_install"></a>`manage_install`

Data type: `Boolean`

A feature flag to toggle the management of the letsencrypt client installation.

Default value: `true`

##### <a name="-letsencrypt--configure_epel"></a>`configure_epel`

Data type: `Boolean`

A feature flag to include the 'epel' class and depend on it for package installation.

Default value: `false`

##### <a name="-letsencrypt--agree_tos"></a>`agree_tos`

Data type: `Boolean`

A flag to agree to the Let's Encrypt Terms of Service.

Default value: `true`

##### <a name="-letsencrypt--unsafe_registration"></a>`unsafe_registration`

Data type: `Boolean`

A flag to allow using the 'register-unsafely-without-email' flag.

Default value: `false`

##### <a name="-letsencrypt--config_dir"></a>`config_dir`

Data type: `Stdlib::Unixpath`

The path to the configuration directory.

Default value: `'/etc/letsencrypt'`

##### <a name="-letsencrypt--key_size"></a>`key_size`

Data type: `Integer[2048]`

Size for the RSA public key

Default value: `4096`

##### <a name="-letsencrypt--certificates"></a>`certificates`

Data type: `Hash[String[1],Hash]`

A hash containing certificates. Each key is the title and each value is a hash, both passed to letsencrypt::certonly.

Default value: `{}`

##### <a name="-letsencrypt--renew_pre_hook_commands"></a>`renew_pre_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell before obtaining/renewing any certificates.

Default value: `[]`

##### <a name="-letsencrypt--renew_post_hook_commands"></a>`renew_post_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell after attempting to obtain/renew certificates.

Default value: `[]`

##### <a name="-letsencrypt--renew_deploy_hook_commands"></a>`renew_deploy_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell once for each successfully issued/renewed
certificate. Two environmental variables are supplied by certbot:
- $RENEWED_LINEAGE: Points to the live directory with the cert files and key.
                    Example: /etc/letsencrypt/live/example.com
- $RENEWED_DOMAINS: A space-delimited list of renewed certificate domains.
                    Example: "example.com www.example.com"

Default value: `[]`

##### <a name="-letsencrypt--renew_additional_args"></a>`renew_additional_args`

Data type: `Variant[String[1], Array[String[1]]]`

Array of additional command line arguments to pass to 'certbot renew'.

Default value: `[]`

##### <a name="-letsencrypt--renew_disable_distro_cron"></a>`renew_disable_distro_cron`

Data type: `Boolean`

Boolean, set to true to disable the cron created by the distro package

Default value: `false`

##### <a name="-letsencrypt--renew_cron_ensure"></a>`renew_cron_ensure`

Data type: `String[1]`

Intended state of the cron resource running certbot renew.

Default value: `'absent'`

##### <a name="-letsencrypt--renew_cron_hour"></a>`renew_cron_hour`

Data type: `Letsencrypt::Cron::Hour`

Optional string, integer or array of hour(s) the renewal command should run.
E.g. '[0,12]' to execute at midnight and midday.
hour.

Default value: `fqdn_rand(24)`

##### <a name="-letsencrypt--renew_cron_minute"></a>`renew_cron_minute`

Data type: `Letsencrypt::Cron::Minute`

Optional string, integer or array of minute(s) the renewal command should
run. E.g. 0 or '00' or [0,30].

Default value: `fqdn_rand(60)`

##### <a name="-letsencrypt--renew_cron_monthday"></a>`renew_cron_monthday`

Data type: `Letsencrypt::Cron::Monthday`

Optional string, integer or array of monthday(s) the renewal command should
run. E.g. '2-30/2' to run on even days.

Default value: `'*'`

##### <a name="-letsencrypt--renew_cron_environment"></a>`renew_cron_environment`

Data type: `Variant[String[1], Array[String[1]]]`

Optional string or array of environments(s) the renewal command should have.
E.g. PATH=/sbin:/usr/sbin:/bin:/usr/bin

Default value: `[]`

##### <a name="-letsencrypt--certonly_pre_hook_commands"></a>`certonly_pre_hook_commands`

Data type: `Array[String[1]]`

Array of commands to run in a shell before obtaining/renewing any certificates.

Default value: `[]`

##### <a name="-letsencrypt--certonly_post_hook_commands"></a>`certonly_post_hook_commands`

Data type: `Array[String[1]]`

Array of commands to run in a shell after attempting to obtain/renew certificates.

Default value: `[]`

##### <a name="-letsencrypt--certonly_deploy_hook_commands"></a>`certonly_deploy_hook_commands`

Data type: `Array[String[1]]`

Array of commands to run in a shell once for each successfully issued/renewed
certificate. Two environmental variables are supplied by certbot:
- $RENEWED_LINEAGE: Points to the live directory with the cert files and key.
                    Example: /etc/letsencrypt/live/example.com
- $RENEWED_DOMAINS: A space-delimited list of renewed certificate domains.
                    Example: "example.com www.example.com"

Default value: `[]`

### <a name="letsencrypt--plugin--dns_cloudflare"></a>`letsencrypt::plugin::dns_cloudflare`

This class installs and configures the Let's Encrypt dns-cloudflare plugin.
https://certbot-dns-cloudflare.readthedocs.io

#### Parameters

The following parameters are available in the `letsencrypt::plugin::dns_cloudflare` class:

* [`package_name`](#-letsencrypt--plugin--dns_cloudflare--package_name)
* [`api_key`](#-letsencrypt--plugin--dns_cloudflare--api_key)
* [`api_token`](#-letsencrypt--plugin--dns_cloudflare--api_token)
* [`email`](#-letsencrypt--plugin--dns_cloudflare--email)
* [`config_path`](#-letsencrypt--plugin--dns_cloudflare--config_path)
* [`manage_package`](#-letsencrypt--plugin--dns_cloudflare--manage_package)
* [`propagation_seconds`](#-letsencrypt--plugin--dns_cloudflare--propagation_seconds)

##### <a name="-letsencrypt--plugin--dns_cloudflare--package_name"></a>`package_name`

Data type: `Optional[String[1]]`

The name of the package to install when $manage_package is true.

Default value: `undef`

##### <a name="-letsencrypt--plugin--dns_cloudflare--api_key"></a>`api_key`

Data type: `Optional[String[1]]`

Optional string, cloudflare api key value for authentication.

Default value: `undef`

##### <a name="-letsencrypt--plugin--dns_cloudflare--api_token"></a>`api_token`

Data type: `Optional[String[1]]`

Optional string, cloudflare api token value for authentication.

Default value: `undef`

##### <a name="-letsencrypt--plugin--dns_cloudflare--email"></a>`email`

Data type: `Optional[String[1]]`

Optional string, cloudflare account email address, used in conjunction with api_key.

Default value: `undef`

##### <a name="-letsencrypt--plugin--dns_cloudflare--config_path"></a>`config_path`

Data type: `Stdlib::Absolutepath`

The path to the configuration directory.

Default value: `"${letsencrypt::config_dir}/dns-cloudflare.ini"`

##### <a name="-letsencrypt--plugin--dns_cloudflare--manage_package"></a>`manage_package`

Data type: `Boolean`

Manage the plugin package.

Default value: `true`

##### <a name="-letsencrypt--plugin--dns_cloudflare--propagation_seconds"></a>`propagation_seconds`

Data type: `Integer`

Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.

Default value: `10`

### <a name="letsencrypt--plugin--dns_linode"></a>`letsencrypt::plugin::dns_linode`

This class installs and configures the Let's Encrypt dns-linode plugin.
https://certbot-dns-linode.readthedocs.io

#### Parameters

The following parameters are available in the `letsencrypt::plugin::dns_linode` class:

* [`package_name`](#-letsencrypt--plugin--dns_linode--package_name)
* [`api_key`](#-letsencrypt--plugin--dns_linode--api_key)
* [`version`](#-letsencrypt--plugin--dns_linode--version)
* [`config_path`](#-letsencrypt--plugin--dns_linode--config_path)
* [`manage_package`](#-letsencrypt--plugin--dns_linode--manage_package)
* [`propagation_seconds`](#-letsencrypt--plugin--dns_linode--propagation_seconds)

##### <a name="-letsencrypt--plugin--dns_linode--package_name"></a>`package_name`

Data type: `Optional[String[1]]`

The name of the package to install when $manage_package is true.

Default value: `undef`

##### <a name="-letsencrypt--plugin--dns_linode--api_key"></a>`api_key`

Data type: `String[1]`

Optional string, linode api key value for authentication.

##### <a name="-letsencrypt--plugin--dns_linode--version"></a>`version`

Data type: `String[1]`

string, linode api version.

Default value: `'4'`

##### <a name="-letsencrypt--plugin--dns_linode--config_path"></a>`config_path`

Data type: `Stdlib::Absolutepath`

The path to the configuration directory.

Default value: `"${letsencrypt::config_dir}/dns-linode.ini"`

##### <a name="-letsencrypt--plugin--dns_linode--manage_package"></a>`manage_package`

Data type: `Boolean`

Manage the plugin package.

Default value: `true`

##### <a name="-letsencrypt--plugin--dns_linode--propagation_seconds"></a>`propagation_seconds`

Data type: `Integer`

Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.

Default value: `120`

### <a name="letsencrypt--plugin--dns_rfc2136"></a>`letsencrypt::plugin::dns_rfc2136`

This class installs and configures the Let's Encrypt dns-rfc2136 plugin.
https://certbot-dns-rfc2136.readthedocs.io

#### Parameters

The following parameters are available in the `letsencrypt::plugin::dns_rfc2136` class:

* [`server`](#-letsencrypt--plugin--dns_rfc2136--server)
* [`key_name`](#-letsencrypt--plugin--dns_rfc2136--key_name)
* [`key_secret`](#-letsencrypt--plugin--dns_rfc2136--key_secret)
* [`key_algorithm`](#-letsencrypt--plugin--dns_rfc2136--key_algorithm)
* [`port`](#-letsencrypt--plugin--dns_rfc2136--port)
* [`propagation_seconds`](#-letsencrypt--plugin--dns_rfc2136--propagation_seconds)
* [`manage_package`](#-letsencrypt--plugin--dns_rfc2136--manage_package)
* [`package_name`](#-letsencrypt--plugin--dns_rfc2136--package_name)
* [`config_dir`](#-letsencrypt--plugin--dns_rfc2136--config_dir)

##### <a name="-letsencrypt--plugin--dns_rfc2136--server"></a>`server`

Data type: `Stdlib::Host`

Target DNS server.

##### <a name="-letsencrypt--plugin--dns_rfc2136--key_name"></a>`key_name`

Data type: `String[1]`

TSIG key name.

##### <a name="-letsencrypt--plugin--dns_rfc2136--key_secret"></a>`key_secret`

Data type: `String[1]`

TSIG key secret.

##### <a name="-letsencrypt--plugin--dns_rfc2136--key_algorithm"></a>`key_algorithm`

Data type: `String[1]`

TSIG key algorithm.

Default value: `'HMAC-SHA512'`

##### <a name="-letsencrypt--plugin--dns_rfc2136--port"></a>`port`

Data type: `Stdlib::Port`

Target DNS port.

Default value: `53`

##### <a name="-letsencrypt--plugin--dns_rfc2136--propagation_seconds"></a>`propagation_seconds`

Data type: `Integer`

Number of seconds to wait for the DNS server to propagate the DNS-01 challenge. (the plugin defaults to 60)

Default value: `10`

##### <a name="-letsencrypt--plugin--dns_rfc2136--manage_package"></a>`manage_package`

Data type: `Boolean`

Manage the plugin package.

Default value: `true`

##### <a name="-letsencrypt--plugin--dns_rfc2136--package_name"></a>`package_name`

Data type: `String[1]`

The name of the package to install when $manage_package is true.

##### <a name="-letsencrypt--plugin--dns_rfc2136--config_dir"></a>`config_dir`

Data type: `Stdlib::Absolutepath`

The path to the configuration directory.

Default value: `$letsencrypt::config_dir`

### <a name="letsencrypt--plugin--dns_route53"></a>`letsencrypt::plugin::dns_route53`

This class installs and configures the Let's Encrypt dns-route53 plugin.
https://certbot-dns-route53.readthedocs.io

#### Parameters

The following parameters are available in the `letsencrypt::plugin::dns_route53` class:

* [`propagation_seconds`](#-letsencrypt--plugin--dns_route53--propagation_seconds)
* [`manage_package`](#-letsencrypt--plugin--dns_route53--manage_package)
* [`package_name`](#-letsencrypt--plugin--dns_route53--package_name)

##### <a name="-letsencrypt--plugin--dns_route53--propagation_seconds"></a>`propagation_seconds`

Data type: `Integer`

Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.

Default value: `10`

##### <a name="-letsencrypt--plugin--dns_route53--manage_package"></a>`manage_package`

Data type: `Boolean`

Manage the plugin package.

Default value: `true`

##### <a name="-letsencrypt--plugin--dns_route53--package_name"></a>`package_name`

Data type: `String[1]`

The name of the package to install when $manage_package is true.

### <a name="letsencrypt--plugin--nginx"></a>`letsencrypt::plugin::nginx`

install and configure the Let's Encrypt nginx plugin

#### Parameters

The following parameters are available in the `letsencrypt::plugin::nginx` class:

* [`manage_package`](#-letsencrypt--plugin--nginx--manage_package)
* [`package_name`](#-letsencrypt--plugin--nginx--package_name)

##### <a name="-letsencrypt--plugin--nginx--manage_package"></a>`manage_package`

Data type: `Boolean`

Manage the plugin package.

Default value: `true`

##### <a name="-letsencrypt--plugin--nginx--package_name"></a>`package_name`

Data type: `String[1]`

The name of the package to install when $manage_package is true.

Default value: `'python3-certbot-nginx'`

### <a name="letsencrypt--renew"></a>`letsencrypt::renew`

Configures renewal of Let's Encrypt certificates using the certbot renew command.

Note: Hooks set here will run before/after/for ALL certificates, including
any not managed by Puppet. If you want to create hooks for specific
certificates only, create them using letsencrypt::certonly.

#### Parameters

The following parameters are available in the `letsencrypt::renew` class:

* [`pre_hook_commands`](#-letsencrypt--renew--pre_hook_commands)
* [`post_hook_commands`](#-letsencrypt--renew--post_hook_commands)
* [`deploy_hook_commands`](#-letsencrypt--renew--deploy_hook_commands)
* [`additional_args`](#-letsencrypt--renew--additional_args)
* [`disable_distro_cron`](#-letsencrypt--renew--disable_distro_cron)
* [`distro_renew_cron_file`](#-letsencrypt--renew--distro_renew_cron_file)
* [`distro_renew_timer`](#-letsencrypt--renew--distro_renew_timer)
* [`cron_ensure`](#-letsencrypt--renew--cron_ensure)
* [`cron_hour`](#-letsencrypt--renew--cron_hour)
* [`cron_minute`](#-letsencrypt--renew--cron_minute)
* [`cron_monthday`](#-letsencrypt--renew--cron_monthday)
* [`cron_environment`](#-letsencrypt--renew--cron_environment)

##### <a name="-letsencrypt--renew--pre_hook_commands"></a>`pre_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell before obtaining/renewing any certificates.

Default value: `$letsencrypt::renew_pre_hook_commands`

##### <a name="-letsencrypt--renew--post_hook_commands"></a>`post_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell after attempting to obtain/renew certificates.

Default value: `$letsencrypt::renew_post_hook_commands`

##### <a name="-letsencrypt--renew--deploy_hook_commands"></a>`deploy_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell once for each successfully issued/renewed
certificate. Two environmental variables are supplied by certbot:
- $RENEWED_LINEAGE: Points to the live directory with the cert files and key.
                    Example: /etc/letsencrypt/live/example.com
- $RENEWED_DOMAINS: A space-delimited list of renewed certificate domains.
                    Example: "example.com www.example.com"

Default value: `$letsencrypt::renew_deploy_hook_commands`

##### <a name="-letsencrypt--renew--additional_args"></a>`additional_args`

Data type: `Array[String[1]]`

Array of additional command line arguments to pass to 'certbot renew'.

Default value: `$letsencrypt::renew_additional_args`

##### <a name="-letsencrypt--renew--disable_distro_cron"></a>`disable_distro_cron`

Data type: `Boolean`

Boolean, set to true to disable the cron created by the distro package

Default value: `$letsencrypt::renew_disable_distro_cron`

##### <a name="-letsencrypt--renew--distro_renew_cron_file"></a>`distro_renew_cron_file`

Data type: `Optional[Stdlib::Unixpath]`

Optional Unixpath, if set and if disable_distro_cron is true this file will be deleted (unless systemd is used)

Default value: `undef`

##### <a name="-letsencrypt--renew--distro_renew_timer"></a>`distro_renew_timer`

Data type: `Optional[String]`

Optional String, name of the systemd timer to disable if disable_distro_cron is true

Default value: `undef`

##### <a name="-letsencrypt--renew--cron_ensure"></a>`cron_ensure`

Data type: `Enum['present', 'absent']`

Intended state of the cron resource running certbot renew

Default value: `$letsencrypt::renew_cron_ensure`

##### <a name="-letsencrypt--renew--cron_hour"></a>`cron_hour`

Data type: `Letsencrypt::Cron::Hour`

Optional string, integer or array of hour(s) the renewal command should run.
E.g. '[0,12]' to execute at midnight and midday. Default: fqdn-seeded random hour.

Default value: `$letsencrypt::renew_cron_hour`

##### <a name="-letsencrypt--renew--cron_minute"></a>`cron_minute`

Data type: `Letsencrypt::Cron::Minute`

Optional string, integer or array of minute(s) the renewal command should
run. E.g. 0 or '00' or [0,30]. Default: fqdn-seeded random minute.

Default value: `$letsencrypt::renew_cron_minute`

##### <a name="-letsencrypt--renew--cron_monthday"></a>`cron_monthday`

Data type: `Letsencrypt::Cron::Monthday`

Optional string, integer or array of monthday(s) the renewal command should
run. E.g. '2-30/2' to run on even days. Default: Every day.

Default value: `$letsencrypt::renew_cron_monthday`

##### <a name="-letsencrypt--renew--cron_environment"></a>`cron_environment`

Data type: `Variant[String[1], Array[String[1]]]`

Optional string or array of environment variables the renewal command should have.
E.g. PATH=/sbin:/usr/sbin:/bin:/usr/bin

Default value: `$letsencrypt::renew_cron_environment`

## Defined types

### <a name="letsencrypt--certonly"></a>`letsencrypt::certonly`

This type can be used to request a certificate using the `certonly` installer.

#### Examples

##### standalone authenticator

```puppet
# Request a certificate for `foo.example.com` using the `certonly`
# installer and the `standalone` authenticator.
letsencrypt::certonly { 'foo.example.com': }
```

##### Multiple domains

```puppet
# Request a certificate for `foo.example.com` and `bar.example.com` using
# the `certonly` installer and the `standalone` authenticator.
letsencrypt::certonly { 'foo':
  domains => ['foo.example.com', 'bar.example.com'],
}
```

##### Apache authenticator

```puppet
# Request a certificate for `foo.example.com` with the `certonly` installer
# and the `apache` authenticator.
letsencrypt::certonly { 'foo.example.com':
  plugin  => 'apache',
}
```

##### Nginx authenticator

```puppet
# Request a certificate for `foo.example.com` with the `certonly` installer
# and the `nginx` authenticator.
letsencrypt::certonly { 'foo.example.com':
  plugin  => 'nginx',
}
```

##### webroot authenticator

```puppet
# Request a certificate using the `webroot` authenticator. The paths to the
# webroots for all domains must be given through `webroot_paths`. If
# `domains` and `webroot_paths` are not the same length, the last
# `webroot_paths` element will be used for all subsequent domains.
letsencrypt::certonly { 'foo':
  domains       => ['foo.example.com', 'bar.example.com'],
  plugin        => 'webroot',
  webroot_paths => ['/var/www/foo', '/var/www/bar'],
}
```

##### dns-rfc2136 authenticator

```puppet
# Request a certificate using the `dns-rfc2136` authenticator. Ideally the
# key `secret` should be encrypted, eg. with eyaml if using Hiera. It's
# also recommended to only enable access to the specific DNS records needed
# by the Let's Encrypt client.
#
# [Plugin documentation](https://certbot-dns-rfc2136.readthedocs.io)
class { 'letsencrypt::plugin::dns_rfc2136':
  server     => '192.0.2.1',
  key_name   => 'certbot',
  key_secret => '[...]==',
}

letsencrypt::certonly { 'foo.example.com':
  plugin        => 'dns-rfc2136',
}
```

##### dns-route53 authenticator

```puppet
# Request a certificate for `foo.example.com` with the `certonly` installer
# and the `dns-route53` authenticator.
letsencrypt::certonly { 'foo.example.com':
  plugin  => 'dns-route53',
}
```

##### Additional arguments

```puppet
# If you need to pass a command line flag to the `certbot` command that
# is not supported natively by this module, you can use the
# `additional_args` parameter to pass those arguments.
letsencrypt::certonly { 'foo.example.com':
  additional_args => ['--foo bar', '--baz quuz'],
}
```

#### Parameters

The following parameters are available in the `letsencrypt::certonly` defined type:

* [`ensure`](#-letsencrypt--certonly--ensure)
* [`domains`](#-letsencrypt--certonly--domains)
* [`custom_plugin`](#-letsencrypt--certonly--custom_plugin)
* [`plugin`](#-letsencrypt--certonly--plugin)
* [`webroot_paths`](#-letsencrypt--certonly--webroot_paths)
* [`letsencrypt_command`](#-letsencrypt--certonly--letsencrypt_command)
* [`additional_args`](#-letsencrypt--certonly--additional_args)
* [`environment`](#-letsencrypt--certonly--environment)
* [`key_size`](#-letsencrypt--certonly--key_size)
* [`manage_cron`](#-letsencrypt--certonly--manage_cron)
* [`cron_output`](#-letsencrypt--certonly--cron_output)
* [`cron_before_command`](#-letsencrypt--certonly--cron_before_command)
* [`cron_success_command`](#-letsencrypt--certonly--cron_success_command)
* [`cron_hour`](#-letsencrypt--certonly--cron_hour)
* [`cron_minute`](#-letsencrypt--certonly--cron_minute)
* [`cron_monthday`](#-letsencrypt--certonly--cron_monthday)
* [`config_dir`](#-letsencrypt--certonly--config_dir)
* [`pre_hook_commands`](#-letsencrypt--certonly--pre_hook_commands)
* [`post_hook_commands`](#-letsencrypt--certonly--post_hook_commands)
* [`deploy_hook_commands`](#-letsencrypt--certonly--deploy_hook_commands)
* [`cert_name`](#-letsencrypt--certonly--cert_name)

##### <a name="-letsencrypt--certonly--ensure"></a>`ensure`

Data type: `Enum['present','absent']`

Intended state of the resource
Will remove certificates for specified domains if set to 'absent'. Will
also remove cronjobs and renewal scripts if `manage_cron` is set to 'true'.

Default value: `'present'`

##### <a name="-letsencrypt--certonly--domains"></a>`domains`

Data type: `Array[String[1]]`

An array of domains to include in the CSR.

Default value: `[$title]`

##### <a name="-letsencrypt--certonly--custom_plugin"></a>`custom_plugin`

Data type: `Boolean`

Whether to use a custom plugin in additional_args and disable -a flag.

Default value: `false`

##### <a name="-letsencrypt--certonly--plugin"></a>`plugin`

Data type: `Letsencrypt::Plugin`

The authenticator plugin to use when requesting the certificate.

Default value: `'standalone'`

##### <a name="-letsencrypt--certonly--webroot_paths"></a>`webroot_paths`

Data type: `Array[Stdlib::Unixpath]`

An array of webroot paths for the domains in `domains`.
Required if using `plugin => 'webroot'`. If `domains` and
`webroot_paths` are not the same length, the last `webroot_paths`
element will be used for all subsequent domains.

Default value: `[]`

##### <a name="-letsencrypt--certonly--letsencrypt_command"></a>`letsencrypt_command`

Data type: `String[1]`

Command to run letsencrypt

Default value: `$letsencrypt::command`

##### <a name="-letsencrypt--certonly--additional_args"></a>`additional_args`

Data type: `Array[String[1]]`

An array of additional command line arguments to pass to the `letsencrypt` command.

Default value: `[]`

##### <a name="-letsencrypt--certonly--environment"></a>`environment`

Data type: `Array[String[1]]`

An optional array of environment variables

Default value: `[]`

##### <a name="-letsencrypt--certonly--key_size"></a>`key_size`

Data type: `Integer[2048]`

Size for the RSA public key

Default value: `$letsencrypt::key_size`

##### <a name="-letsencrypt--certonly--manage_cron"></a>`manage_cron`

Data type: `Boolean`

Indicating whether or not to schedule cron job for renewal.
Runs daily but only renews if near expiration, e.g. within 10 days.

Default value: `false`

##### <a name="-letsencrypt--certonly--cron_output"></a>`cron_output`

Data type: `Optional[Enum['suppress', 'log']]`

How to treat cron output
`suppress` - Suppress all output
`log` - Forward cron output to syslog
undef - Do nothing with cron output (default)

Default value: `undef`

##### <a name="-letsencrypt--certonly--cron_before_command"></a>`cron_before_command`

Data type: `Optional[String[1]]`

Representation of a command that should be run before renewal command

Default value: `undef`

##### <a name="-letsencrypt--certonly--cron_success_command"></a>`cron_success_command`

Data type: `Optional[String[1]]`

Representation of a command that should be run if the renewal command succeeds.

Default value: `undef`

##### <a name="-letsencrypt--certonly--cron_hour"></a>`cron_hour`

Data type: `Variant[Integer[0,23], String, Array]`

Optional hour(s) that the renewal command should execute.
e.g. '[0,12]' execute at midnight and midday.  Default - seeded random hour, twice a day.

Default value: `[fqdn_rand(12, $title), fqdn_rand(12, $title) + 12]`

##### <a name="-letsencrypt--certonly--cron_minute"></a>`cron_minute`

Data type: `Variant[Integer[0,59], String, Array]`

Optional minute(s) that the renewal command should execute.
e.g. 0 or '00' or [0,30].  Default - seeded random minute.

Default value: `fqdn_rand(60, $title)`

##### <a name="-letsencrypt--certonly--cron_monthday"></a>`cron_monthday`

Data type: `Array[Variant[Integer[0, 59], String[1]]]`

Optional string, integer or array of monthday(s) the renewal command should
run. E.g. '2-30/2' to run on even days. Default: Every day.

Default value: `['*']`

##### <a name="-letsencrypt--certonly--config_dir"></a>`config_dir`

Data type: `Stdlib::Unixpath`

The path to the configuration directory.

Default value: `$letsencrypt::config_dir`

##### <a name="-letsencrypt--certonly--pre_hook_commands"></a>`pre_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of commands to run in a shell before attempting to obtain/renew the certificate.

Default value: `$letsencrypt::certonly_pre_hook_commands`

##### <a name="-letsencrypt--certonly--post_hook_commands"></a>`post_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of command(s) to run in a shell after attempting to obtain/renew the certificate.

Default value: `$letsencrypt::certonly_post_hook_commands`

##### <a name="-letsencrypt--certonly--deploy_hook_commands"></a>`deploy_hook_commands`

Data type: `Variant[String[1], Array[String[1]]]`

Array of command(s) to run in a shell once if the certificate is successfully issued.
Two environmental variables are supplied by certbot:
- $RENEWED_LINEAGE: Points to the live directory with the cert files and key.
                    Example: /etc/letsencrypt/live/example.com
- $RENEWED_DOMAINS: A space-delimited list of renewed certificate domains.
                    Example: "example.com www.example.com"

Default value: `$letsencrypt::certonly_deploy_hook_commands`

##### <a name="-letsencrypt--certonly--cert_name"></a>`cert_name`

Data type: `String[1]`

the common name used for the certificate

Default value: `$domains[0]`

### <a name="letsencrypt--hook"></a>`letsencrypt::hook`

This type is used by letsencrypt::renew and letsencrypt::certonly to create hook scripts.

#### Parameters

The following parameters are available in the `letsencrypt::hook` defined type:

* [`type`](#-letsencrypt--hook--type)
* [`hook_file`](#-letsencrypt--hook--hook_file)
* [`commands`](#-letsencrypt--hook--commands)

##### <a name="-letsencrypt--hook--type"></a>`type`

Data type: `Enum['pre', 'post', 'deploy']`

Hook type.

##### <a name="-letsencrypt--hook--hook_file"></a>`hook_file`

Data type: `String[1]`

Path to deploy hook script.

##### <a name="-letsencrypt--hook--commands"></a>`commands`

Data type: `Variant[String[1],Array[String[1]]]`

Bash commands to execute when the hook is run by certbot.

## Functions

### <a name="letsencrypt--letsencrypt_lookup"></a>`letsencrypt::letsencrypt_lookup`

Type: Ruby 4.x API

The letsencrypt::letsencrypt_lookup function.

#### `letsencrypt::letsencrypt_lookup(Any $common_name)`

The letsencrypt::letsencrypt_lookup function.

Returns: `Any`

##### `common_name`

Data type: `Any`



## Data types

### <a name="Letsencrypt--Cron--Hour"></a>`Letsencrypt::Cron::Hour`

mimic hour setting in cron as defined in man 5 crontab

Alias of

```puppet
Variant[Integer[0,23], String[1], Array[
    Variant[
      Integer[0,23],
      String[1],
    ]
  ]]
```

### <a name="Letsencrypt--Cron--Minute"></a>`Letsencrypt::Cron::Minute`

mimic minute setting in cron as defined in man 5 crontab

Alias of

```puppet
Variant[Integer[0,59], String[1], Array[
    Variant[
      Integer[0,59],
      String[1],
    ]
  ]]
```

### <a name="Letsencrypt--Cron--Monthday"></a>`Letsencrypt::Cron::Monthday`

mimic monthday setting in cron as defined in man 5 crontab

Alias of

```puppet
Variant[Integer[0,31], String[1], Array[
    Variant[
      Integer[0,31],
      String[1],
    ]
  ]]
```

### <a name="Letsencrypt--Plugin"></a>`Letsencrypt::Plugin`

List of accepted plugins

Alias of `Enum['apache', 'standalone', 'webroot', 'nginx', 'dns-azure', 'dns-route53', 'dns-google', 'dns-cloudflare', 'dns-linode', 'dns-rfc2136', 'manual']`

