# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.2.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.2.0) (2017-11-21)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.1.0...v2.2.0)

**Merged pull requests:**

- Update vcsrepo requirement \(smaller 3\) [\#107](https://github.com/voxpupuli/puppet-letsencrypt/pull/107) ([kallies](https://github.com/kallies))
- Remove EOL operatingsystems [\#106](https://github.com/voxpupuli/puppet-letsencrypt/pull/106) ([ekohl](https://github.com/ekohl))

## [v2.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.1.0) (2017-11-13)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.0.1...v2.1.0)

**Implemented enhancements:**

- Added custom\_plugin param in certonly to disable use of '-a' flag. [\#84](https://github.com/voxpupuli/puppet-letsencrypt/pull/84) ([Lavaburn](https://github.com/Lavaburn))

**Closed issues:**

- Puppet support in readme and metadata.json conflicts [\#102](https://github.com/voxpupuli/puppet-letsencrypt/issues/102)
- Could not find declared class ::letsencrypt [\#101](https://github.com/voxpupuli/puppet-letsencrypt/issues/101)
- Please issue a new release [\#54](https://github.com/voxpupuli/puppet-letsencrypt/issues/54)

**Merged pull requests:**

- release 2.1.0 [\#104](https://github.com/voxpupuli/puppet-letsencrypt/pull/104) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.0.1) (2017-09-17)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.0.0...v2.0.1)

**Merged pull requests:**

- release 2.0.1 [\#100](https://github.com/voxpupuli/puppet-letsencrypt/pull/100) ([bastelfreak](https://github.com/bastelfreak))
- fixed randomness if the domain is almost same [\#96](https://github.com/voxpupuli/puppet-letsencrypt/pull/96) ([ashish1099](https://github.com/ashish1099))

## [v2.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.0.0) (2017-06-22)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v1.1.0...v2.0.0)

**Merged pull requests:**

- release 2.0.0 [\#95](https://github.com/voxpupuli/puppet-letsencrypt/pull/95) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with proper puppet4 datatypes [\#93](https://github.com/voxpupuli/puppet-letsencrypt/pull/93) ([bastelfreak](https://github.com/bastelfreak))
- Use the correct package names on Debian [\#88](https://github.com/voxpupuli/puppet-letsencrypt/pull/88) ([ekohl](https://github.com/ekohl))
- fix "-":12: command too long. errors in crontab file, can't install. [\#87](https://github.com/voxpupuli/puppet-letsencrypt/pull/87) ([saimonn](https://github.com/saimonn))
- Added ability to suppress cron output [\#79](https://github.com/voxpupuli/puppet-letsencrypt/pull/79) ([grega](https://github.com/grega))

## [v1.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v1.1.0) (2017-02-11)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v1.0.1...v1.1.0)

**Merged pull requests:**

- Removing --quiet from certonly cron [\#74](https://github.com/voxpupuli/puppet-letsencrypt/pull/74) ([craigwatson](https://github.com/craigwatson))
- unbreak console output by ensuring actual text output [\#65](https://github.com/voxpupuli/puppet-letsencrypt/pull/65) ([igalic](https://github.com/igalic))
- Add cron\_before\_command [\#48](https://github.com/voxpupuli/puppet-letsencrypt/pull/48) ([gkopylov](https://github.com/gkopylov))

## [v1.0.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v1.0.1) (2016-12-23)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v999.999.999...v1.0.1)

**Merged pull requests:**

- Bump minimum version dependencies \(for Puppet 4\) [\#72](https://github.com/voxpupuli/puppet-letsencrypt/pull/72) ([juniorsysadmin](https://github.com/juniorsysadmin))
- release 1.0.1 [\#71](https://github.com/voxpupuli/puppet-letsencrypt/pull/71) ([bastelfreak](https://github.com/bastelfreak))
- Typo cerbot -\> certbot in README.md [\#68](https://github.com/voxpupuli/puppet-letsencrypt/pull/68) ([rudibroekhuizen](https://github.com/rudibroekhuizen))

## [v999.999.999](https://github.com/voxpupuli/puppet-letsencrypt/tree/v999.999.999) (2016-12-20)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v1.0.0...v999.999.999)

**Closed issues:**

- 1.0.0 and 0.4.0 packages in puppetforge broken [\#46](https://github.com/voxpupuli/puppet-letsencrypt/issues/46)
- undefined method `cycle'  [\#37](https://github.com/voxpupuli/puppet-letsencrypt/issues/37)
- Duplicate declaration: Package\[git\] is already declared in file  [\#29](https://github.com/voxpupuli/puppet-letsencrypt/issues/29)
- Using certonly in webroot mode fails with "can't convert Enumerable::Enumerator into Array" [\#28](https://github.com/voxpupuli/puppet-letsencrypt/issues/28)
- Command Questions [\#26](https://github.com/voxpupuli/puppet-letsencrypt/issues/26)
- Invalid resource type ini\_setting [\#22](https://github.com/voxpupuli/puppet-letsencrypt/issues/22)
- Folders "\~/.local\..." bug [\#19](https://github.com/voxpupuli/puppet-letsencrypt/issues/19)
- vcs-installed letsencrypt-auto creates '~' directory [\#16](https://github.com/voxpupuli/puppet-letsencrypt/issues/16)
- Update to the latest lets-encrypt version: v0.4.0 [\#14](https://github.com/voxpupuli/puppet-letsencrypt/issues/14)
- Alternative Puppet Module [\#4](https://github.com/voxpupuli/puppet-letsencrypt/issues/4)

**Merged pull requests:**

- Bump LetsEncrypt version to 0.9.3 \(latest as of Oct 2016\)  [\#61](https://github.com/voxpupuli/puppet-letsencrypt/pull/61) ([jethrocarr](https://github.com/jethrocarr))
- Fix cronspam [\#60](https://github.com/voxpupuli/puppet-letsencrypt/pull/60) ([jethrocarr](https://github.com/jethrocarr))
- Fix failing builds [\#57](https://github.com/voxpupuli/puppet-letsencrypt/pull/57) ([jethrocarr](https://github.com/jethrocarr))
- Certbot [\#49](https://github.com/voxpupuli/puppet-letsencrypt/pull/49) ([cpitkin](https://github.com/cpitkin))
- Remove webroot\_paths cycling to match domains list [\#42](https://github.com/voxpupuli/puppet-letsencrypt/pull/42) ([danzilio](https://github.com/danzilio))
- Validate presence of webroot\_paths with webroot plugin [\#39](https://github.com/voxpupuli/puppet-letsencrypt/pull/39) ([domcleal](https://github.com/domcleal))
- Fix validation of letsencrypt\_command [\#38](https://github.com/voxpupuli/puppet-letsencrypt/pull/38) ([domcleal](https://github.com/domcleal))
- Various smaller fixes. [\#36](https://github.com/voxpupuli/puppet-letsencrypt/pull/36) ([thomasvs](https://github.com/thomasvs))
- Change EL7 package and command to certbot [\#35](https://github.com/voxpupuli/puppet-letsencrypt/pull/35) ([domcleal](https://github.com/domcleal))
- Add a way to change package name and command [\#34](https://github.com/voxpupuli/puppet-letsencrypt/pull/34) ([glorpen](https://github.com/glorpen))
- Defaults for el7 [\#33](https://github.com/voxpupuli/puppet-letsencrypt/pull/33) ([danzilio](https://github.com/danzilio))
- Closes \#18: merging @mheistermann's changes [\#32](https://github.com/voxpupuli/puppet-letsencrypt/pull/32) ([danzilio](https://github.com/danzilio))
- Added optional 'environment' parameter to init and certonly. Specced. [\#30](https://github.com/voxpupuli/puppet-letsencrypt/pull/30) ([tomgillett](https://github.com/tomgillett))
- Split letsencrypt commands, so -auto is only used once [\#27](https://github.com/voxpupuli/puppet-letsencrypt/pull/27) ([lazyfrosch](https://github.com/lazyfrosch))
- Fixing test failures when STRICT\_VARIABLES is set to true [\#25](https://github.com/voxpupuli/puppet-letsencrypt/pull/25) ([danzilio](https://github.com/danzilio))
- Update client [\#24](https://github.com/voxpupuli/puppet-letsencrypt/pull/24) ([lazyfrosch](https://github.com/lazyfrosch))
- Fix \#16 by specifying VENV\_PATH when running letsencrypt. [\#17](https://github.com/voxpupuli/puppet-letsencrypt/pull/17) ([mheistermann](https://github.com/mheistermann))
- Changing default version to 0.4.0 [\#15](https://github.com/voxpupuli/puppet-letsencrypt/pull/15) ([as0bu](https://github.com/as0bu))

## [v1.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v1.0.0) (2016-02-22)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.4.0...v1.0.0)

**Merged pull requests:**

- updating changelog and prepping metadata for release as 1.0 [\#13](https://github.com/voxpupuli/puppet-letsencrypt/pull/13) ([danzilio](https://github.com/danzilio))
- Change Puppet 4 specifics to support 3.4+ [\#12](https://github.com/voxpupuli/puppet-letsencrypt/pull/12) ([domcleal](https://github.com/domcleal))
- Install LE package on EL7, Ubuntu 16.04 and Debian 9+ [\#11](https://github.com/voxpupuli/puppet-letsencrypt/pull/11) ([domcleal](https://github.com/domcleal))

## [v0.4.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.4.0) (2016-02-01)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.3.2...v0.4.0)

**Merged pull requests:**

- Added webroot\_paths parameter [\#10](https://github.com/voxpupuli/puppet-letsencrypt/pull/10) ([stephenwade](https://github.com/stephenwade))
- Add --agree-tos to commands [\#9](https://github.com/voxpupuli/puppet-letsencrypt/pull/9) ([stephenwade](https://github.com/stephenwade))
- add optional cron job for certificate renewal [\#8](https://github.com/voxpupuli/puppet-letsencrypt/pull/8) ([hdeadman](https://github.com/hdeadman))

## [v0.3.2](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.3.2) (2015-12-14)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.3.1...v0.3.2)

**Merged pull requests:**

- use -a to define plugin [\#7](https://github.com/voxpupuli/puppet-letsencrypt/pull/7) ([timogoebel](https://github.com/timogoebel))
- Replace package with ensure\_packages [\#6](https://github.com/voxpupuli/puppet-letsencrypt/pull/6) ([AndreaGiardini](https://github.com/AndreaGiardini))

## [v0.3.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.3.1) (2015-12-08)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.3.0...v0.3.1)

## [v0.3.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.3.0) (2015-12-08)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.2.0...v0.3.0)

**Merged pull requests:**

- Adding support for RedHat and improving config [\#5](https://github.com/voxpupuli/puppet-letsencrypt/pull/5) ([danzilio](https://github.com/danzilio))
- Fix style in examples [\#3](https://github.com/voxpupuli/puppet-letsencrypt/pull/3) ([ghoneycutt](https://github.com/ghoneycutt))
- Fix test context with not supported operating systems [\#2](https://github.com/voxpupuli/puppet-letsencrypt/pull/2) ([AndreaGiardini](https://github.com/AndreaGiardini))
- A collection of commits working toward getting this to v1 [\#1](https://github.com/voxpupuli/puppet-letsencrypt/pull/1) ([ghoneycutt](https://github.com/ghoneycutt))

## [v0.2.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.2.0) (2015-12-03)
[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v0.1.0...v0.2.0)

## [v0.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v0.1.0) (2015-12-03)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*