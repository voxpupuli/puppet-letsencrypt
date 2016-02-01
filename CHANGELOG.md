# Change log
All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

## [0.4.0] - 2016-01-31
### Added
- Ability to renew automatically via cron with `manage_cron` parameter.
- Ability to manage multiple webroots with `webroot_paths` parameter.

### Change
- Added `--agree-tos` to the `letsencrypt` commands.
- Use `ensure_packages` instead of a `package` resource for the dependencies.

## [0.3.2] - 2015-12-14
### Changed
- Using the `-a` parameter to define the plugin instead of `--<plugin_name>`.
- Dependencies are now defined with `ensure_packages` instead of the `package` resource.

## [0.3.1] - 2015-12-08
### Added
- Pushing an updated CHANGELOG (forgot to do this with 0.3.0)

## [0.3.0] - 2015-12-08
### Added
- Added `email`, `agree_tos`, and `unsafe_registration` parameters.
- Added support for RedHat (no real changes here: verified that the module works, updated `metadata.json` and removed the artificial constraint).
- Made the configuration more opinionated by requiring valid registration settings and requiring the user to agree to the Terms of Service.

### Changed
- The `email` parameter or an `email` key in `$config` is now required. This may break existing functionality where users were not specifying an email address.
- Broke the configuration out into a `config` class.

## [0.2.0] - 2015-12-03
### Added
- Added `additional_args` parameter to `letsencrypt::certonly`

## [0.1.0] - 2015-12-03
Initial Release

[unreleased]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/danzilio/puppet-letsencrypt/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/danzilio/puppet-letsencrypt/tree/v0.1.0
