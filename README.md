# Let's Encrypt

[![Build Status](https://travis-ci.org/voxpupuli/puppet-letsencrypt.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-letsencrypt)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/letsencrypt.svg)](https://forge.puppetlabs.com/puppet/letsencrypt)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/letsencrypt.svg)](https://forge.puppetlabs.com/puppet/letsencrypt)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/letsencrypt.svg)](https://forge.puppetlabs.com/puppet/letsencrypt)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/letsencrypt.svg)](https://forge.puppetlabs.com/puppet/letsencrypt)
[![Documentation Status](http://img.shields.io/badge/docs-puppet--strings-ff69b4.svg?style=flat)](http://voxpupuli.github.io/puppet-letsencrypt)

This module installs the Let's Encrypt client (certbot) and allows you to request certificates.

## Support

This module is currently only written to work on Debian and RedHat based
operating systems, although it may work on others. The supported Puppet
versions are defined in the [metadata.json](metadata.json)

## Dependencies

On EL (Red Hat, CentOS etc.) systems, the EPEL repository needs to be enabled
for the Let's Encrypt client package.

The module can integrate with [puppet/epel](https://forge.puppetlabs.com/puppet/epel)
to set up the repo by setting the `configure_epel` parameter to `true` (the default for RedHat) and
installing the module.

## Usage

### Setting up the Let's Encrypt client

To install the Let's Encrypt client with the default configuration settings you
must provide your email address to register with the Let's Encrypt servers:

```puppet
class { 'letsencrypt':
  email => 'foo@example.com',
}
```

You can enforce upgrade of package to the latest available version (in your repositories):

```puppet
class { 'letsencrypt':
  email          => 'foo@example.com',
  package_ensure => 'latest',
}
```

If using EL7 without EPEL-preconfigured, add `configure_epel`:

```puppet
class { 'letsencrypt':
  configure_epel => true,
  email          => 'foo@example.com',
}
```

(If you manage epel some other way, disable it with `configure_epel => false`.)

This will install the Let's Encrypt client and its dependencies, agree to the
Terms of Service, initialize the client, and install a configuration file for
the client.

Alternatively, you can specify your email address in the $config hash:

```puppet
class { 'letsencrypt':
  config => {
    email  => 'foo@example.com',
    server => 'https://acme-v01.api.letsencrypt.org/directory',
  }
}
```

During testing, you probably want to direct to the staging server instead with
`server => 'https://acme-staging-v02.api.letsencrypt.org/directory'`

If you don't wish to provide your email address, you can set the
`unsafe_registration` parameter to `true` (this is not recommended):

```puppet
class { 'letsencrypt':
  unsafe_registration => true,
}
```

To request a wildcard certificate, you must use the ACME v2 endpoint and use
a DNS-01 challenge. See
https://community.letsencrypt.org/t/acme-v2-production-environment-wildcards/55578

```puppet
class { 'letsencrypt':
  config => {
    email  => 'foo@example.com',
    server => 'https://acme-v02.api.letsencrypt.org/directory',
  }
}
```

### Issuing certificates

Create `letsencrypt::certonly` defines. See the `letsencrypt::certonly` examples in the REFERENCE.md for more details.


### Renewing certificates

There are two ways to automatically renew certificates with cron using this module.

#### cron using certbot renew

All installed certificates will be renewed using `certbot renew` using their
original settings, including any not managed by Puppet.

* `renew_cron_ensure` manages the cron resource. Set to `present` to enable. Default: `absent`
* `renew_cron_minute` sets minute(s) to run the cron job. Default: Seeded random minute
* `renew_cron_hour` sets hour(s) to run the cron job. Default: Seeded random hour
* `renew_cron_monthday` sets month day(s) to run the cron job. Default: Every day

```puppet
class { 'letsencrypt':
  config => {
    email  => 'foo@example.com',
    server => 'https://acme-v01.api.letsencrypt.org/directory',
  },
  renew_cron_ensure => 'present',
}
```

With Hiera, at 6 AM (roughly) every other day:

```yaml
---
letsencrypt::renew_cron_ensure: 'present'
letsencrypt::renew_cron_minute: 0
letsencrypt::renew_cron_hour: 6
letsencrypt::renew_cron_monthday: '1-31/2'
```

#### cron using certbot certonly

Only specific certificates will be renewed using `certbot certonly`.

* `manage_cron` can be used to automatically renew the certificate
* `cron_success_command` can be used to run a shell command on a successful renewal
* `cron_before_command` can be used to run a shell command before a renewal
* `cron_monthday` can be used to specify one or multiple days of the month to run the cron job (defaults to every day)
* `cron_hour` can be used to specify hour(s) to run the cron job (defaults to a seeded random hour)
* `cron_minute` can be used to specify minute(s) to run the cron job (defaults to a seeded random minute)
* `cron_output` can be used to disable output (and resulting emails) generated by the cron command

```puppet
letsencrypt::certonly { 'foo':
  domains              => ['foo.example.com', 'bar.example.com'],
  manage_cron          => true,
  cron_hour            => [0,12],
  cron_minute          => '30',
  cron_before_command  => 'service nginx stop',
  cron_success_command => '/bin/systemctl reload nginx.service',
  cron_output          => 'suppress',
}
```

#### Deprovisioning

If a domain needs to be removed for any reason this can be done by setting
`ensure` to 'absent', this will remove the certificates for this domain from
the server. If `manage_cron` is set to true, the certificate renewal cronjob
and shell scripts for the domain will also be removed.

```puppet
letsencrypt::certonly { 'foo':
  ensure      => 'absent',
  domains     => ['foo.example.com', 'bar.example.com'],
  manage_cron => true,
}
```

## Hooks

Certbot supports hooks since certbot v0.5.0, however this module uses the newer
`--deploy-hook` replacing the deprecated `--renew-hook`. Because of this the
minimum version you will need to manage hooks with this module is v0.17.0.

All hook command parameters support both string and array.

**Note on certbot hook behavior:** Hooks created by `letsencrypt::certonly` will be
configured in the renewal config file of the certificate by certbot (stored in
CONFIG_DIR/renewal/), which means all hooks created this way are used when running
`certbot renew` without hook arguments. This allows you to easily create individual
hooks for each certificate with just one cron job for renewal. HOWEVER, when running
`certbot renew` with any of the hook arguments (setting any of the
`letsencrypt::renew_*_hook_commands` parameters), hooks of the corresponding
types in all renewal configs will be ignored by certbot. It's recommended to keep
these two ways of using hooks mutually exclusive to avoid confusion. Cron jobs
created by `letsencrypt::certonly` are unaffected as they renew certificates
directly using `certbot certonly`.

### certbot certonly

Hooks created with `letsencrypt::certonly` will behave the following way:

* `pre` hooks will be run before each certificate is attempted issued or renewed,
even if the action fails.
* `post` hooks will be run after each certificate is attempted issued or renewed,
even if the action fails.
* `deploy` hooks will be run after successfully issuing or renewing each certificate.
It will not be run if no action is taken or if the action fails.

```puppet
letsencrypt::certonly { 'foo':
  domains               => ['foo.example.com', 'bar.example.com'],
  pre_hook_commands     => ['...'],
  post_hook_commands    => ['...'],
  deploy_hook_commands  => ['...'],
}
```

### certbot renew

Hooks passed to `certbot renew` will behave the following way:

* `pre` hook will be run once total before any certificates are attempted issued
or renewed. It will not be run if no actions are taken. Overrides all pre hooks
created by `letsencrypt::certonly`.
* `post` hook will be run once total after all certificates are issued or renewed.
It will not be run if no actions are taken. Overrides all post hooks created by
`letsencrypt::certonly`.
* `deploy` hook will be run once for each successfully issued or renewed certificate.
It will not be run otherwise. Overrides all deploy hooks created by
`letsencrypt::certonly`.

```puppet
class { 'letsencrypt':
  config => {
    email  => 'foo@example.com',
    server => 'https://acme-v01.api.letsencrypt.org/directory',
  },
  renew_pre_hook_commands: [...],
  renew_post_hook_commands: [...],
  renew_deploy_hook_commands: [...],
}
```

With Hiera:

```yaml
---
letsencrypt::renew_pre_hook_commands:
  - '...'
letsencrypt::renew_post_hook_commands:
  - '...'
letsencrypt::renew_deploy_hook_commands:
  - '...'
```

## Facts

* [certbot_version](#fact-certbotversion)
* [letsencrypt_directory](#fact-letsencryptdirectory)

### Fact: certbot_version

A fact that contains the current version of certbot installed on your operating system/distribution.

### Fact: letsencrypt_directory

Facts about your live certificates are available through facter. You can query the list of live certificates from puppet using `$facts['letsencrypt_directory']` in your puppet code, hiera data or from the command line.

```
facter -p letsencrypt_directory
{
  legacyfiles.ijc.org => "/etc/letsencrypt/live/legacyfiles.ijc.org",
  static.ijc.org => "/etc/letsencrypt/live/static.ijc.org",
  ijc.org => "/etc/letsencrypt/live/ijc.org",
  new.ijc.org => "/etc/letsencrypt/live/new.ijc.org",
  www.ijc.org => "/etc/letsencrypt/live/ijc.org",
  training.ijc.org => "/etc/letsencrypt/live/training.ijc.org"
}
```

## Puppet Functions

This module profiles a custom puppet function `letsencrypt::letsencrypt_lookup` which allows you to load information about your certificates into puppet.
This returns the same information as in the facts but for a particular domain. It accepts a single argument for your domain or wildcard domain.

## Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered. If you need help, just ask!
