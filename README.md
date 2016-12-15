[![Puppet Forge](http://img.shields.io/puppetforge/v/danzilio/certbot.svg?style=flat)](https://forge.puppetlabs.com/danzilio/certbot) [![Build Status](https://travis-ci.org/danzilio/puppet-certbot.svg)](https://travis-ci.org/danzilio/puppet-certbot) [![Documentation Status](http://img.shields.io/badge/docs-puppet--strings-ff69b4.svg?style=flat)](http://danzilio.github.io/puppet-certbot)

This module installs the `certbot` Let's Encrypt client from source and allows you to request certificates.

## Support

This module requires Puppet >= 3.4. and is currently only written to work on
Debian and RedHat based operating systems, although it may work on others.

## Dependencies

On EL (Red Hat, CentOS etc.) systems, the EPEL repository needs to be enabled
for the `certbot` package.

The module can integrate with [stahnma/epel](https://forge.puppetlabs.com/stahnma/epel)
to set up the repo by setting the `configure_epel` parameter to `true` (the default for RedHat) and
installing the module.

## Usage

To install `certbot` with the default configuration settings you must provide
your email address to register with the Let's Encrypt servers:

```puppet
class { ::certbot:
  email => 'foo@example.com',
}
```

If using EL7 without EPEL-preconfigured, add `configure_epel`:

```puppet
class { ::certbot:
  configure_epel => true,
  email          => 'foo@example.com',
}
```

(If you manage epel some other way, disable it with `configure_epel => false`.)

This will install `certbot` and its dependencies, agree to the Terms of Service,
initialize the client, and install a configuration file for the client.

Alternatively, you can specify your email address in the $config hash:

```puppet
class { ::certbot:
  config => {
    email  => 'foo@example.com',
    server => 'https://acme-v01.api.letsencrypt.org/directory',
  }
}
```
During testing, you probably want to direct to the staging server instead with
`server => 'https://acme-staging.api.letsencrypt.org/directory'`


If you don't wish to provide your email address, you can set the
`unsafe_registration` parameter to `true` (this is not recommended):

```puppet
class { ::certbot:
  unsafe_registration => true,
}
```

To request a certificate for `foo.example.com` using the `certonly` installer
and the `standalone` authenticator:

```puppet
certbot::certonly { 'foo.example.com': }
```

To request a certificate for `foo.example.com` and `bar.example.com` with the
`certonly` installer and the `apache` authenticator:

```puppet
certbot::certonly { 'foo':
  domains => ['foo.example.com', 'bar.example.com'],
  plugin  => 'apache',
}
```

To request a certificate using the `webroot` plugin, the paths to the webroots
for all domains must be given through `webroot_paths`. If `domains` and
`webroot_paths` are not the same length, the last `webroot_paths` element will
be used for all subsequent domains.

```puppet
certbot::certonly { 'foo':
  domains       => ['foo.example.com', 'bar.example.com'],
  plugin        => 'webroot',
  webroot_paths => ['/var/www/foo', '/var/www/bar'],
}
```

If you need to pass a command line flag to the `certbot-auto` command that
is not supported natively by this module, you can use the `additional_args`
parameter to pass those arguments:

```puppet
certbot::certonly { 'foo':
  domains         => ['foo.example.com', 'bar.example.com'],
  plugin          => 'apache',
  additional_args => ['--foo bar', '--baz quuz'],
}
```

To automatically renew a certificate, you can pass the `manage_cron` parameter.
You can optionally add a shell command to be run on success using the `cron_success_command` parameter.

```puppet
certbot::certonly { 'foo':
  domains => ['foo.example.com', 'bar.example.com'],
  manage_cron => true,
  cron_success_command => '/bin/systemctl reload nginx.service',
}
```

## Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered. If you need help, just ask!
