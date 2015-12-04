[![Puppet Forge](http://img.shields.io/puppetforge/v/danzilio/letsencrypt.svg?style=flat)](https://forge.puppetlabs.com/danzilio/letsencrypt) [![Build Status](https://travis-ci.org/danzilio/puppet-letsencrypt.svg)](https://travis-ci.org/danzilio/puppet-letsencrypt) [![Documentation Status](http://img.shields.io/badge/docs-puppet--strings-ff69b4.svg?style=flat)](http://danzilio.github.io/puppet-letsencrypt)

This module installs the Letsencrypt client from source and allows you to request certificates.

## Support

This module requires Puppet >= 4.0. and is currently only written to work on
Debian-based operating systems.

## Usage

To install the Letsencrypt client with the default configuration settings:

```puppet
include ::letsencrypt
```

To request a certificate for `foo.example.com` using the `certonly` installer
and the `standalone` authenticator:

```puppet
letsencrypt::certonly { 'foo.example.com': }
```

To request a certificate for `foo.example.com` and `bar.example.com` with the
`certonly` installer and the `apache` authenticator:

```puppet
letsencrypt::certonly { 'foo':
  domains => ['foo.example.com', 'bar.example.com'],
  plugin  => 'apache',
}
```

If you need to pass a command line flag to the `letsencrypt-auto` command that
is not supported natively by this module, you can use the `additional_args`
parameter to pass those arguments:

```puppet
letsencrypt::certonly { 'foo':
  domains         => ['foo.example.com', 'bar.example.com'],
  plugin          => 'apache',
  additional_args => ['--foo bar', '--baz quuz'],
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
