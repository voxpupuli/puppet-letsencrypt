# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v11.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v11.1.0) (2024-09-09)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v11.0.0...v11.1.0)

**Implemented enhancements:**

- remove the 'root' group and replace with group 0 [\#355](https://github.com/voxpupuli/puppet-letsencrypt/pull/355) ([rtprio](https://github.com/rtprio))
- Add support for FreeBSD 14 [\#350](https://github.com/voxpupuli/puppet-letsencrypt/pull/350) ([smortex](https://github.com/smortex))
- Add environment parameter to renew cron [\#288](https://github.com/voxpupuli/puppet-letsencrypt/pull/288) ([gmenuel](https://github.com/gmenuel))

## [v11.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v11.0.0) (2023-12-04)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v10.1.0...v11.0.0)

**Breaking changes:**

- Add support for Fedora 39, drop support for Fedora 36 [\#336](https://github.com/voxpupuli/puppet-letsencrypt/pull/336) ([kenyon](https://github.com/kenyon))
- certonly: Use the first domain for `$cert_name` instead of the `$title` [\#220](https://github.com/voxpupuli/puppet-letsencrypt/pull/220) ([saimonn](https://github.com/saimonn))

**Implemented enhancements:**

- Add Puppet 8 support [\#324](https://github.com/voxpupuli/puppet-letsencrypt/pull/324) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- plugins: avoid circular dependencies [\#332](https://github.com/voxpupuli/puppet-letsencrypt/pull/332) ([kenyon](https://github.com/kenyon))

**Merged pull requests:**

- Mark `install.pp` as private [\#338](https://github.com/voxpupuli/puppet-letsencrypt/pull/338) ([kenyon](https://github.com/kenyon))
- move `letsencrypt::configure_epel` from hiera to `init.pp` [\#337](https://github.com/voxpupuli/puppet-letsencrypt/pull/337) ([kenyon](https://github.com/kenyon))
- Remove legacy top-scope syntax [\#335](https://github.com/voxpupuli/puppet-letsencrypt/pull/335) ([smortex](https://github.com/smortex))

## [v10.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v10.1.0) (2023-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v10.0.0...v10.1.0)

**Implemented enhancements:**

- replace obsolete merge function [\#333](https://github.com/voxpupuli/puppet-letsencrypt/pull/333) ([vchepkov](https://github.com/vchepkov))

## [v10.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v10.0.0) (2023-09-27)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v9.2.0...v10.0.0)

**Breaking changes:**

- Drop support for Debian 10 \(EOL\) [\#330](https://github.com/voxpupuli/puppet-letsencrypt/pull/330) ([evgeni](https://github.com/evgeni))
- Drop support for Ubuntu 18.04 \(EOL\) [\#329](https://github.com/voxpupuli/puppet-letsencrypt/pull/329) ([evgeni](https://github.com/evgeni))
- Drop Puppet 6 support [\#318](https://github.com/voxpupuli/puppet-letsencrypt/pull/318) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Allow puppetlabs/inifile 6.x, puppet/epel 5.x [\#327](https://github.com/voxpupuli/puppet-letsencrypt/pull/327) ([evgeni](https://github.com/evgeni))
- puppetlabs/stdlib: Allow 9.x [\#323](https://github.com/voxpupuli/puppet-letsencrypt/pull/323) ([bastelfreak](https://github.com/bastelfreak))
- Add a `certbot_version` fact [\#322](https://github.com/voxpupuli/puppet-letsencrypt/pull/322) ([martijndegouw](https://github.com/martijndegouw))

**Fixed bugs:**

- Propagate the package\_ensure parameter to all plugins [\#321](https://github.com/voxpupuli/puppet-letsencrypt/pull/321) ([martijndegouw](https://github.com/martijndegouw))

## [v9.2.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v9.2.0) (2023-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v9.1.0...v9.2.0)

**Implemented enhancements:**

- Add missing datatypes and documentation [\#315](https://github.com/voxpupuli/puppet-letsencrypt/pull/315) ([bastelfreak](https://github.com/bastelfreak))
- Add EL9 support [\#314](https://github.com/voxpupuli/puppet-letsencrypt/pull/314) ([bastelfreak](https://github.com/bastelfreak))
- Add CentOS 8 support [\#313](https://github.com/voxpupuli/puppet-letsencrypt/pull/313) ([bastelfreak](https://github.com/bastelfreak))
- Add Rocky 8 support [\#312](https://github.com/voxpupuli/puppet-letsencrypt/pull/312) ([bastelfreak](https://github.com/bastelfreak))
- certonly: Implement default hook commands [\#311](https://github.com/voxpupuli/puppet-letsencrypt/pull/311) ([bastelfreak](https://github.com/bastelfreak))
- Remove unnecessary exec [\#309](https://github.com/voxpupuli/puppet-letsencrypt/pull/309) ([deric](https://github.com/deric))

## [v9.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v9.1.0) (2023-01-15)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v9.0.1...v9.1.0)

**Implemented enhancements:**

- Add dns-azure to allowed plugins [\#298](https://github.com/voxpupuli/puppet-letsencrypt/pull/298) ([yachub](https://github.com/yachub))

## [v9.0.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v9.0.1) (2022-12-02)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v9.0.0...v9.0.1)

**Fixed bugs:**

- Update REFERENCE.md with recent breaking changes [\#303](https://github.com/voxpupuli/puppet-letsencrypt/pull/303) ([treydock](https://github.com/treydock))

**Closed issues:**

- Documentation/examples for certonly `suppress_cron_output` not updated after removal of parameter [\#302](https://github.com/voxpupuli/puppet-letsencrypt/issues/302)

## [v9.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v9.0.0) (2022-11-21)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v8.0.2...v9.0.0)

**Breaking changes:**

- Drop Fedora 32, add Fedora 36 support [\#301](https://github.com/voxpupuli/puppet-letsencrypt/pull/301) ([treydock](https://github.com/treydock))
- Update FreeBSD package names [\#296](https://github.com/voxpupuli/puppet-letsencrypt/pull/296) ([smortex](https://github.com/smortex))
- Support logging cron output [\#277](https://github.com/voxpupuli/puppet-letsencrypt/pull/277) ([treydock](https://github.com/treydock))

**Implemented enhancements:**

- Add support for ubuntu 22.04 [\#297](https://github.com/voxpupuli/puppet-letsencrypt/pull/297) ([cible](https://github.com/cible))
- Allow using the 'manual' plugin [\#292](https://github.com/voxpupuli/puppet-letsencrypt/pull/292) ([smokris](https://github.com/smokris))
- Reduce acceptance test duplication [\#282](https://github.com/voxpupuli/puppet-letsencrypt/pull/282) ([ekohl](https://github.com/ekohl))
- Configure Debian as an OS family [\#280](https://github.com/voxpupuli/puppet-letsencrypt/pull/280) ([ekohl](https://github.com/ekohl))
- Add Cloudflare DNS plugin support [\#279](https://github.com/voxpupuli/puppet-letsencrypt/pull/279) ([bkuebler](https://github.com/bkuebler))

**Fixed bugs:**

- Fix misuse of fqdn\_rand\_string [\#291](https://github.com/voxpupuli/puppet-letsencrypt/pull/291) ([smokris](https://github.com/smokris))
- Fix registration after an unsafe one [\#287](https://github.com/voxpupuli/puppet-letsencrypt/pull/287) ([neomilium](https://github.com/neomilium))

## [v8.0.2](https://github.com/voxpupuli/puppet-letsencrypt/tree/v8.0.2) (2022-02-01)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v8.0.1...v8.0.2)

**Fixed bugs:**

- move scripts into a separate class [\#275](https://github.com/voxpupuli/puppet-letsencrypt/pull/275) ([nod0n](https://github.com/nod0n))

## [v8.0.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v8.0.1) (2022-01-20)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v8.0.0...v8.0.1)

**Fixed bugs:**

- Don't use reserved words [\#273](https://github.com/voxpupuli/puppet-letsencrypt/pull/273) ([nod0n](https://github.com/nod0n))

## [v8.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v8.0.0) (2022-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v7.0.0...v8.0.0)

**Implemented enhancements:**

- create certificates from class parameter \(hiera\) [\#271](https://github.com/voxpupuli/puppet-letsencrypt/pull/271) ([nod0n](https://github.com/nod0n))
- FreeBSD dns plugin packages [\#268](https://github.com/voxpupuli/puppet-letsencrypt/pull/268) ([nod0n](https://github.com/nod0n))
- install and use the certbot nginx plugin [\#267](https://github.com/voxpupuli/puppet-letsencrypt/pull/267) ([nod0n](https://github.com/nod0n))

**Merged pull requests:**

- generate REFERENCE.md [\#266](https://github.com/voxpupuli/puppet-letsencrypt/pull/266) ([nod0n](https://github.com/nod0n))
- Drop obsolete operating system version check in acceptance tests [\#265](https://github.com/voxpupuli/puppet-letsencrypt/pull/265) ([nod0n](https://github.com/nod0n))

## [v7.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v7.0.0) (2021-12-10)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v6.0.0...v7.0.0)

**Breaking changes:**

- Drop VCS install method support [\#246](https://github.com/voxpupuli/puppet-letsencrypt/issues/246)
- Update FreeBSD package name [\#253](https://github.com/voxpupuli/puppet-letsencrypt/pull/253) ([smortex](https://github.com/smortex))
- Drop support for Debian 9, Ubuntu 16.04 and FreeBSD 11 \(EOL\) [\#251](https://github.com/voxpupuli/puppet-letsencrypt/pull/251) ([smortex](https://github.com/smortex))
- modulesync 4.1.0 / Drop EoL Puppet 5 / Drop VCS install method [\#235](https://github.com/voxpupuli/puppet-letsencrypt/pull/235) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for Debian 11 and FreeBSD 13 [\#252](https://github.com/voxpupuli/puppet-letsencrypt/pull/252) ([smortex](https://github.com/smortex))
- support for Ubuntu 20.04 [\#247](https://github.com/voxpupuli/puppet-letsencrypt/pull/247) ([lschierer](https://github.com/lschierer))

**Closed issues:**

- Raise compatible puppet version from \<7.0 to \<8.0 [\#245](https://github.com/voxpupuli/puppet-letsencrypt/issues/245)
- certbot-auto no longer works on any OS [\#240](https://github.com/voxpupuli/puppet-letsencrypt/issues/240)
- Logrotate for the letsencrypt logs [\#237](https://github.com/voxpupuli/puppet-letsencrypt/issues/237)
- RHEL8 support for dns-rfc2136 [\#236](https://github.com/voxpupuli/puppet-letsencrypt/issues/236)
- Cut new version with puppet-epel dependency? [\#232](https://github.com/voxpupuli/puppet-letsencrypt/issues/232)
- module complains about missing provider variable [\#209](https://github.com/voxpupuli/puppet-letsencrypt/issues/209)
- wrong initialize script  [\#154](https://github.com/voxpupuli/puppet-letsencrypt/issues/154)

**Merged pull requests:**

- Allow epel 4 [\#261](https://github.com/voxpupuli/puppet-letsencrypt/pull/261) ([msalway](https://github.com/msalway))
- remove .sync.yml with only Travis settings [\#260](https://github.com/voxpupuli/puppet-letsencrypt/pull/260) ([kenyon](https://github.com/kenyon))
- docs: wording updates due to removal of VCS install method [\#259](https://github.com/voxpupuli/puppet-letsencrypt/pull/259) ([kenyon](https://github.com/kenyon))
- init.pp: remove unused param $manage\_dependencies [\#258](https://github.com/voxpupuli/puppet-letsencrypt/pull/258) ([kenyon](https://github.com/kenyon))
- README: not installing from source anymore; fix staging URL [\#257](https://github.com/voxpupuli/puppet-letsencrypt/pull/257) ([kenyon](https://github.com/kenyon))
- dns\_rfc2136\_spec, dns\_route53\_spec: add Fedora 32, drop Fedora 30, 31 [\#256](https://github.com/voxpupuli/puppet-letsencrypt/pull/256) ([kenyon](https://github.com/kenyon))
- Add support for RHEL 8 and AlmaLinux 8 [\#254](https://github.com/voxpupuli/puppet-letsencrypt/pull/254) ([yachub](https://github.com/yachub))
- Allow up-to-date dependencies [\#248](https://github.com/voxpupuli/puppet-letsencrypt/pull/248) ([smortex](https://github.com/smortex))
- Add quote marks to class names in readme [\#242](https://github.com/voxpupuli/puppet-letsencrypt/pull/242) ([thebeanogamer](https://github.com/thebeanogamer))

## [v6.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v6.0.0) (2020-09-11)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v5.0.0...v6.0.0)

**Breaking changes:**

- modulesync 2.10.0 / Drop FreeBSD 10 / Add FreeBSD 12 [\#213](https://github.com/voxpupuli/puppet-letsencrypt/pull/213) ([dhoppe](https://github.com/dhoppe))

**Implemented enhancements:**

- add manifest to install dns-route53 plugin, along with tests [\#225](https://github.com/voxpupuli/puppet-letsencrypt/pull/225) ([aripringle](https://github.com/aripringle))
- Add `cert_name` parameter to `letsencrypt::certonly` [\#219](https://github.com/voxpupuli/puppet-letsencrypt/pull/219) ([saimonn](https://github.com/saimonn))

**Closed issues:**

- typo in example [\#227](https://github.com/voxpupuli/puppet-letsencrypt/issues/227)
- update metadata.json [\#218](https://github.com/voxpupuli/puppet-letsencrypt/issues/218)

**Merged pull requests:**

- modulesync 3.0.0 & puppet-lint updates [\#229](https://github.com/voxpupuli/puppet-letsencrypt/pull/229) ([bastelfreak](https://github.com/bastelfreak))
- fix typo in renew example [\#228](https://github.com/voxpupuli/puppet-letsencrypt/pull/228) ([milesstoetzner](https://github.com/milesstoetzner))
- Use voxpupuli-acceptance [\#224](https://github.com/voxpupuli/puppet-letsencrypt/pull/224) ([ekohl](https://github.com/ekohl))
- Ensure EPEL is configured before installing plugin [\#222](https://github.com/voxpupuli/puppet-letsencrypt/pull/222) ([alexjfisher](https://github.com/alexjfisher))
- \#218 Switch to puppet-epel [\#221](https://github.com/voxpupuli/puppet-letsencrypt/pull/221) ([kallies](https://github.com/kallies))
- Add Fedora 31, drop Fedora 29 [\#216](https://github.com/voxpupuli/puppet-letsencrypt/pull/216) ([ekohl](https://github.com/ekohl))
- delete legacy travis directory [\#214](https://github.com/voxpupuli/puppet-letsencrypt/pull/214) ([bastelfreak](https://github.com/bastelfreak))
- add --keep-until-expiring closer to letsencrypt command in cron [\#211](https://github.com/voxpupuli/puppet-letsencrypt/pull/211) ([pulecp](https://github.com/pulecp))
- allow puppetlabs/inifile 4.x [\#210](https://github.com/voxpupuli/puppet-letsencrypt/pull/210) ([bastelfreak](https://github.com/bastelfreak))

## [v5.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v5.0.0) (2019-10-09)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v4.0.0...v5.0.0)

**Breaking changes:**

- remove params.pp and change some defaults values [\#205](https://github.com/voxpupuli/puppet-letsencrypt/pull/205) ([Dan33l](https://github.com/Dan33l))
- Drop Ubuntu 14.04 & add Debian 9/10 / Fedora 29/30 support [\#193](https://github.com/voxpupuli/puppet-letsencrypt/pull/193) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- replace server urls with v2 urls [\#196](https://github.com/voxpupuli/puppet-letsencrypt/issues/196)
- Option to clean up cronjobs for removed domains [\#175](https://github.com/voxpupuli/puppet-letsencrypt/issues/175)
- update version shiped with vcs method to 0.39.0 [\#207](https://github.com/voxpupuli/puppet-letsencrypt/pull/207) ([Dan33l](https://github.com/Dan33l))
- use ACME API v2 [\#206](https://github.com/voxpupuli/puppet-letsencrypt/pull/206) ([Dan33l](https://github.com/Dan33l))
- feat\(facts\): add facts about certificates [\#187](https://github.com/voxpupuli/puppet-letsencrypt/pull/187) ([minorOffense](https://github.com/minorOffense))

**Fixed bugs:**

- fix modulesync config file [\#201](https://github.com/voxpupuli/puppet-letsencrypt/pull/201) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- python2-certbot-dns-rfc2136 doesn't exist in debian buster [\#191](https://github.com/voxpupuli/puppet-letsencrypt/issues/191)
- letsencrypt failed to generate certificate [\#184](https://github.com/voxpupuli/puppet-letsencrypt/issues/184)
- `$letsencrypt::venv_path` is undocumented [\#21](https://github.com/voxpupuli/puppet-letsencrypt/issues/21)

**Merged pull requests:**

- use puppet strings [\#204](https://github.com/voxpupuli/puppet-letsencrypt/pull/204) ([Dan33l](https://github.com/Dan33l))
- Raise upper bound version of stdlib & vcsrepo [\#202](https://github.com/voxpupuli/puppet-letsencrypt/pull/202) ([mfaure](https://github.com/mfaure))
- Fix type in readme: deploy\_hooks\_commands -\> deploy\_hook\_commands [\#188](https://github.com/voxpupuli/puppet-letsencrypt/pull/188) ([2ZZ](https://github.com/2ZZ))
- Allow puppetlabs/inifile 3.x [\#186](https://github.com/voxpupuli/puppet-letsencrypt/pull/186) ([dhoppe](https://github.com/dhoppe))

## [v4.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v4.0.0) (2019-03-29)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Rework letsencrypt::certonly for \#175 [\#177](https://github.com/voxpupuli/puppet-letsencrypt/pull/177) ([cFire](https://github.com/cFire))
- Certonly: Refactor manage\_cron to ensure\_cron with appropriate data type [\#161](https://github.com/voxpupuli/puppet-letsencrypt/pull/161) ([craigwatson](https://github.com/craigwatson))

**Implemented enhancements:**

- Add support for certbot renew and hooks [\#174](https://github.com/voxpupuli/puppet-letsencrypt/pull/174) ([Rathios](https://github.com/Rathios))
- Add support for wildcard certs [\#171](https://github.com/voxpupuli/puppet-letsencrypt/pull/171) ([Rathios](https://github.com/Rathios))
- Add support for dns-rfc2136 plugin [\#169](https://github.com/voxpupuli/puppet-letsencrypt/pull/169) ([Rathios](https://github.com/Rathios))
- Add ability to control keysize. Default to 4096. [\#165](https://github.com/voxpupuli/puppet-letsencrypt/pull/165) ([treveradams](https://github.com/treveradams))

**Fixed bugs:**

- Fix for $live\_path variable [\#180](https://github.com/voxpupuli/puppet-letsencrypt/pull/180) ([cFire](https://github.com/cFire))
- \#178 Add single quote around all domains names in shell commands [\#179](https://github.com/voxpupuli/puppet-letsencrypt/pull/179) ([Turgon37](https://github.com/Turgon37))
- Fedora doesn't use EPEL for certbot/letsencrypt. [\#166](https://github.com/voxpupuli/puppet-letsencrypt/pull/166) ([treveradams](https://github.com/treveradams))
- Fix exec onlyif logic [\#151](https://github.com/voxpupuli/puppet-letsencrypt/pull/151) ([baurmatt](https://github.com/baurmatt))

**Closed issues:**

- Domain wildcard should be escaped or quoted in shell commands [\#178](https://github.com/voxpupuli/puppet-letsencrypt/issues/178)
- Upgrade letsencrypt to 0.30.2 [\#172](https://github.com/voxpupuli/puppet-letsencrypt/issues/172)
- Disabling manage-cron does not remove crontab record [\#139](https://github.com/voxpupuli/puppet-letsencrypt/issues/139)
- Add support for certbot hooks [\#56](https://github.com/voxpupuli/puppet-letsencrypt/issues/56)

**Merged pull requests:**

- surfacing package\_ensure in README [\#181](https://github.com/voxpupuli/puppet-letsencrypt/pull/181) ([Dan33l](https://github.com/Dan33l))
- Upgrade vcs version to 0.30.2 [\#173](https://github.com/voxpupuli/puppet-letsencrypt/pull/173) ([baurmatt](https://github.com/baurmatt))
- Add Fedora to tested systems list. [\#168](https://github.com/voxpupuli/puppet-letsencrypt/pull/168) ([treveradams](https://github.com/treveradams))

## [v3.0.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v3.0.0) (2019-01-14)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.5.0...v3.0.0)

**Breaking changes:**

- vcs method, bump version of certbot to v0.30.0 [\#159](https://github.com/voxpupuli/puppet-letsencrypt/pull/159) ([Dan33l](https://github.com/Dan33l))
- modulesync 2.5.0  and drop Puppet4 support  [\#156](https://github.com/voxpupuli/puppet-letsencrypt/pull/156) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Update to support puppetlabs/vcsrepo 2 [\#98](https://github.com/voxpupuli/puppet-letsencrypt/issues/98)
- Update to support puppetlabs/inifile 2 [\#97](https://github.com/voxpupuli/puppet-letsencrypt/issues/97)
- Improve performance of unless [\#148](https://github.com/voxpupuli/puppet-letsencrypt/pull/148) ([baurmatt](https://github.com/baurmatt))
- Add cron day of month parameter [\#146](https://github.com/voxpupuli/puppet-letsencrypt/pull/146) ([brigriffin](https://github.com/brigriffin))
- Added support for dns-cloudflare CertBot plugin. [\#145](https://github.com/voxpupuli/puppet-letsencrypt/pull/145) ([nick-dasilva](https://github.com/nick-dasilva))
- make the module compatible with FreeBSD [\#143](https://github.com/voxpupuli/puppet-letsencrypt/pull/143) ([Wayneoween](https://github.com/Wayneoween))
- Allow wildcard domains for certonly::domains [\#142](https://github.com/voxpupuli/puppet-letsencrypt/pull/142) ([Wimmesberger](https://github.com/Wimmesberger))
- Add cron time parameters [\#122](https://github.com/voxpupuli/puppet-letsencrypt/pull/122) ([matonb](https://github.com/matonb))

**Fixed bugs:**

- Using a space in the letsencrypt::certonly title creates a cron script that will never run. [\#91](https://github.com/voxpupuli/puppet-letsencrypt/issues/91)
- \#91: Cron should also run with space in certonly title [\#113](https://github.com/voxpupuli/puppet-letsencrypt/pull/113) ([siebrand](https://github.com/siebrand))

**Closed issues:**

- wrong repository for EFF's tool to obtain certs from Let's Encrypt [\#153](https://github.com/voxpupuli/puppet-letsencrypt/issues/153)
- Add support for Certbot dns\_cloudflare plugin. [\#144](https://github.com/voxpupuli/puppet-letsencrypt/issues/144)
- Cronjob needs the options --text --non-interactive [\#55](https://github.com/voxpupuli/puppet-letsencrypt/issues/55)
- This module should not manage git package [\#53](https://github.com/voxpupuli/puppet-letsencrypt/issues/53)
- Add dependencies as a parameter [\#52](https://github.com/voxpupuli/puppet-letsencrypt/issues/52)
- Spec tests break on the "certbot -h" command [\#44](https://github.com/voxpupuli/puppet-letsencrypt/issues/44)
- Testing: Change the server or use --staging? [\#43](https://github.com/voxpupuli/puppet-letsencrypt/issues/43)
- letsencrypt package is now called certbot [\#41](https://github.com/voxpupuli/puppet-letsencrypt/issues/41)
- No letsencrypt package for centos 6? [\#31](https://github.com/voxpupuli/puppet-letsencrypt/issues/31)
- rebuild module [\#20](https://github.com/voxpupuli/puppet-letsencrypt/issues/20)

**Merged pull requests:**

- add ubuntu 18.04 as supported OS [\#158](https://github.com/voxpupuli/puppet-letsencrypt/pull/158) ([Dan33l](https://github.com/Dan33l))
- use certbot repository [\#155](https://github.com/voxpupuli/puppet-letsencrypt/pull/155) ([Dan33l](https://github.com/Dan33l))

## [v2.5.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.5.0) (2018-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- Migrate letsencrypt::config::ini helper to native Puppet 4 [\#136](https://github.com/voxpupuli/puppet-letsencrypt/pull/136) ([baurmatt](https://github.com/baurmatt))
- Add support for dns-google plugin support [\#134](https://github.com/voxpupuli/puppet-letsencrypt/pull/134) ([jocado](https://github.com/jocado))

**Fixed bugs:**

- Adding extra domain fails [\#94](https://github.com/voxpupuli/puppet-letsencrypt/issues/94)
- Bug/proper domain validation [\#137](https://github.com/voxpupuli/puppet-letsencrypt/pull/137) ([baurmatt](https://github.com/baurmatt))

**Closed issues:**

- Support certbot dns-google plugin [\#133](https://github.com/voxpupuli/puppet-letsencrypt/issues/133)
- Don't use cron::environment [\#125](https://github.com/voxpupuli/puppet-letsencrypt/issues/125)

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#140](https://github.com/voxpupuli/puppet-letsencrypt/pull/140) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x [\#135](https://github.com/voxpupuli/puppet-letsencrypt/pull/135) ([bastelfreak](https://github.com/bastelfreak))
- Fix cron environment leaking [\#126](https://github.com/voxpupuli/puppet-letsencrypt/pull/126) ([baurmatt](https://github.com/baurmatt))

## [v2.4.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.4.0) (2018-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.3.0...v2.4.0)

**Implemented enhancements:**

- Support dns-route53 plugin [\#123](https://github.com/voxpupuli/puppet-letsencrypt/pull/123) ([jwm](https://github.com/jwm))
- Allow custom config dir; FreeBSD support [\#117](https://github.com/voxpupuli/puppet-letsencrypt/pull/117) ([a01fe](https://github.com/a01fe))
- Fixes \#81 added -n flag to certbot to run in unattended mode. [\#112](https://github.com/voxpupuli/puppet-letsencrypt/pull/112) ([K0HAX](https://github.com/K0HAX))

**Closed issues:**

- route53 plugin support [\#118](https://github.com/voxpupuli/puppet-letsencrypt/issues/118)

**Merged pull requests:**

- Remove docker nodesets [\#121](https://github.com/voxpupuli/puppet-letsencrypt/pull/121) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#120](https://github.com/voxpupuli/puppet-letsencrypt/pull/120) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.3.0) (2018-02-28)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Add OpenBSD support [\#114](https://github.com/voxpupuli/puppet-letsencrypt/pull/114) ([arthurbarton](https://github.com/arthurbarton))

**Closed issues:**

- Run fails on prompt during certonly if certs are not yet due for renewal [\#81](https://github.com/voxpupuli/puppet-letsencrypt/issues/81)

## [v2.2.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.2.0) (2018-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.1.0...v2.2.0)

**Merged pull requests:**

- bump inifile dependency to allow 2.x [\#109](https://github.com/voxpupuli/puppet-letsencrypt/pull/109) ([bastelfreak](https://github.com/bastelfreak))
- release 2.2.0 [\#108](https://github.com/voxpupuli/puppet-letsencrypt/pull/108) ([bastelfreak](https://github.com/bastelfreak))
- Update vcsrepo requirement \(smaller 3\) [\#107](https://github.com/voxpupuli/puppet-letsencrypt/pull/107) ([kallies](https://github.com/kallies))
- Remove EOL operatingsystems [\#106](https://github.com/voxpupuli/puppet-letsencrypt/pull/106) ([ekohl](https://github.com/ekohl))

## [v2.1.0](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.1.0) (2017-11-13)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.0.1...v2.1.0)

**Implemented enhancements:**

- Added custom\_plugin param in certonly to disable use of '-a' flag. [\#84](https://github.com/voxpupuli/puppet-letsencrypt/pull/84) ([Lavaburn](https://github.com/Lavaburn))

**Closed issues:**

- Puppet support in readme and metadata.json conflicts [\#102](https://github.com/voxpupuli/puppet-letsencrypt/issues/102)
- Could not find declared class letsencrypt [\#101](https://github.com/voxpupuli/puppet-letsencrypt/issues/101)
- Please issue a new release [\#54](https://github.com/voxpupuli/puppet-letsencrypt/issues/54)

## [v2.0.1](https://github.com/voxpupuli/puppet-letsencrypt/tree/v2.0.1) (2017-09-17)

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/v2.0.0...v2.0.1)

**Merged pull requests:**

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
- Changing default version to 0.4.0 [\#15](https://github.com/voxpupuli/puppet-letsencrypt/pull/15) ([serialh0bbyist](https://github.com/serialh0bbyist))

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

[Full Changelog](https://github.com/voxpupuli/puppet-letsencrypt/compare/12019701ec328a3e8ed152ef4eb8a6f0f7524467...v0.1.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
