# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::certonly' do
  on_supported_os.each do |os, facts|
    context "on #{os} based operating systems" do
      let :facts do
        facts
      end

      let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com', package_command => 'letsencrypt' }" }

      # FreeBSD uses a different filesystem path
      pathprefix = facts[:kernel] == 'FreeBSD' ? '/usr/local' : ''

      context 'with a single domain' do
        let(:title) { 'foo.example.com' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('Letsencrypt::Install') }
        it { is_expected.to contain_class('Letsencrypt::Config') }
        it { is_expected.to contain_class('Letsencrypt::Scripts') }

        # letsencrypt::scripts is a private class and is therefore tested in this define
        it 'contains the domain validation script' do
          is_expected.to contain_file('/usr/local/sbin/letsencrypt-domain-validation').
            with_ensure('file').
            with_owner('root').
            with_group('root').
            with_mode('0500').
            with_content(%r{#!/bin/sh})
        end

        if facts[:osfamily] == 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/letsencrypt') }
          it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com') }
          it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini server https://acme-v02.api.letsencrypt.org/directory') }
        else
          it { is_expected.to contain_file('/etc/letsencrypt') }
          it { is_expected.to contain_package('letsencrypt') }
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v02.api.letsencrypt.org/directory') }
        end
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_unless(['test ! -f /usr/local/sbin/letsencrypt-domain-validation', "/usr/local/sbin/letsencrypt-domain-validation #{pathprefix}/etc/letsencrypt/live/foo.example.com/cert.pem 'foo.example.com'"]) }
      end

      context 'with ensure absent' do
        let(:title) { 'foo.example.com' }
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive delete --cert-name 'foo.example.com'" }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_onlyif "/usr/local/sbin/letsencrypt-domain-validation #{pathprefix}/etc/letsencrypt/live/foo.example.com/cert.pem 'foo.example.com'" }
      end

      context 'with multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com', '*.example.com'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo' -d 'foo.example.com' -d 'bar.example.com' -d '*.example.com'" }
      end

      context 'with custom cert-name' do
        let(:title) { 'foo' }
        let(:params) { { cert_name: 'bar.example.com' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'bar.example.com' -d 'foo'" }
      end

      context 'with custom command' do
        let(:title) { 'foo.example.com' }
        let(:params) { { letsencrypt_command: '/usr/lib/letsencrypt/letsencrypt-auto' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/usr/lib/letsencrypt/letsencrypt-auto --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name \'foo.example.com\' -d \'foo.example.com\'' }
      end

      context 'with webroot plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          { plugin: 'webroot',
            webroot_paths: ['/var/www/foo'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a webroot --cert-name 'foo.example.com' --webroot-path /var/www/foo -d 'foo.example.com'" }
      end

      context 'with webroot plugin and multiple domains' do
        let(:title) { 'foo' }
        let(:params) do
          { domains: ['foo.example.com', 'bar.example.com'],
            plugin: 'webroot',
            webroot_paths: ['/var/www/foo', '/var/www/bar'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a webroot --cert-name 'foo' --webroot-path /var/www/foo -d 'foo.example.com' --webroot-path /var/www/bar -d 'bar.example.com'" }
      end

      context 'with webroot plugin, one webroot, and multiple domains' do
        let(:title) { 'foo' }
        let(:params) do
          { domains: ['foo.example.com', 'bar.example.com'],
            plugin: 'webroot',
            webroot_paths: ['/var/www/foo'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a webroot --cert-name 'foo' --webroot-path /var/www/foo -d 'foo.example.com' -d 'bar.example.com'" }
      end

      context 'with webroot plugin and no webroot_paths' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'webroot' } }

        it { is_expected.not_to compile.with_all_deps }
        it { is_expected.to raise_error Puppet::Error, %r{'webroot_paths' parameter must be specified} }
      end

      context 'with dns-rfc2136 plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'dns-rfc2136', letsencrypt_command: 'letsencrypt' } }
        let(:pre_condition) do
          <<-PUPPET
          class { 'letsencrypt':
            email      => 'foo@example.com',
            config_dir => '/etc/letsencrypt',
          }
          class { 'letsencrypt::plugin::dns_rfc2136':
            server         => '192.0.2.1',
            key_name       => 'certbot',
            key_secret     => 'secret',
            package_name   => 'irrelevant',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('letsencrypt::plugin::dns_rfc2136') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a dns-rfc2136 --cert-name 'foo.example.com' -d 'foo.example.com' --dns-rfc2136-credentials /etc/letsencrypt/dns-rfc2136.ini --dns-rfc2136-propagation-seconds 10" }
      end

      context 'with dns-route53 plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'dns-route53', letsencrypt_command: 'letsencrypt' } }
        let(:pre_condition) do
          <<-PUPPET
          class { 'letsencrypt':
            email      => 'foo@example.com',
            config_dir => '/etc/letsencrypt',
          }
          class { 'letsencrypt::plugin::dns_route53':
            package_name   => 'irrelevant',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('letsencrypt::plugin::dns_route53') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a dns-route53 --cert-name 'foo.example.com' -d 'foo.example.com' --dns-route53-propagation-seconds 10" }
      end

      context 'with nginx plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'nginx', letsencrypt_command: 'letsencrypt' } }
        let(:pre_condition) do
          <<-PUPPET
          class { 'letsencrypt':
            email      => 'foo@example.com',
            config_dir => '/etc/letsencrypt',
          }
          class { 'letsencrypt::plugin::nginx':
            package_name   => 'irrelevant',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('letsencrypt::plugin::nginx') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a nginx --cert-name 'foo.example.com' -d 'foo.example.com'" }
      end

      context 'with dns-cloudflare plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'dns-cloudflare', letsencrypt_command: 'letsencrypt' } }
        let(:pre_condition) do
          <<-PUPPET
          class { 'letsencrypt':
            email      => 'foo@example.com',
            config_dir => '/etc/letsencrypt',
          }
          class { 'letsencrypt::plugin::dns_cloudflare':
            package_name => 'irrelevant',
            api_token    => 'dummy-cloudflare-api-token',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('letsencrypt::plugin::dns_cloudflare') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a dns-cloudflare --cert-name 'foo.example.com' -d 'foo.example.com' --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/dns-cloudflare.ini --dns-cloudflare-propagation-seconds 10" }
      end

      context 'with custom plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a apache --cert-name 'foo.example.com' -d 'foo.example.com'" }
      end

      context 'with custom plugin and manage_cron' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            plugin: 'apache',
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command('"/var/lib/puppet/letsencrypt/renew-foo.example.com.sh"').with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a apache --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with hook' do
        context 'pre' do
          let(:title) { 'foo.example.com' }
          let(:params) { { config_dir: '/etc/letsencrypt', pre_hook_commands: ['FooBar'] } }

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_letsencrypt__hook('foo.example.com-pre').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-pre.sh')
          end
        end

        context 'pre with wildcard domain' do
          let(:title) { '*.example.com' }
          let(:params) { { config_dir: '/etc/letsencrypt', pre_hook_commands: ['FooBar'] } }

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_letsencrypt__hook('*.example.com-pre').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/example.com-pre.sh')
          end
        end

        context 'post' do
          let(:title) { 'foo.example.com' }
          let(:params) { { config_dir: '/etc/letsencrypt', post_hook_commands: ['FooBar'] } }

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_letsencrypt__hook('foo.example.com-post').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-post.sh')
          end
        end

        context 'deploy' do
          let(:title) { 'foo.example.com' }
          let(:params) { { config_dir: '/etc/letsencrypt', deploy_hook_commands: ['FooBar'] } }

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_letsencrypt__hook('foo.example.com-deploy').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-deploy.sh')
          end
        end
      end

      context 'with manage_cron and defined cron_hour (integer)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_hour: 13,
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_hour(13).with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and out of range defined cron_hour (integer)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_hour: 24,
            manage_cron: true
          }
        end

        it { is_expected.not_to compile.with_all_deps }
        it { is_expected.to raise_error Puppet::Error }
      end

      context 'with manage_cron and defined cron_hour (string)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_hour: '00',
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_hour('00').with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and defined cron_hour (array)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_hour: [1, 13],
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_hour([1, 13]).with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and defined cron_minute (integer)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_minute: 15,
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_minute(15).with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and defined cron_minute (string)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_minute: '15',
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_minute('15').with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and defined cron_minute (array)' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            cron_minute: [0, 30],
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_minute([0, 30]).with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with manage_cron and ensure absent' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            ensure: 'absent',
            manage_cron: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_ensure('absent') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('absent') }
      end

      context 'with custom puppet_vardir path and manage_cron' do
        let :facts do
          super().merge(puppet_vardir: '/tmp/custom_vardir')
        end
        let(:title) { 'foo.example.com' }
        let(:params) do
          { plugin: 'apache',
            manage_cron: true }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/tmp/custom_vardir/letsencrypt').with_ensure('directory') }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command '"/tmp/custom_vardir/letsencrypt/renew-foo.example.com.sh"' }
        it { is_expected.to contain_file('/tmp/custom_vardir/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a apache --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with custom plugin and manage cron and cron_success_command' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          {
            plugin: 'apache',
            manage_cron: true,
            cron_before_command: 'echo before',
            cron_success_command: 'echo success'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command '"/var/lib/puppet/letsencrypt/renew-foo.example.com.sh"' }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\n(echo before) && letsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a apache --cert-name 'foo.example.com' -d 'foo.example.com' && (echo success)\n") }
      end

      context 'without plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { custom_plugin: true } }

        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 --cert-name 'foo.example.com' -d 'foo.example.com'" }
      end

      context 'with invalid plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'bad' } }

        it { is_expected.not_to compile.with_all_deps }
        it { is_expected.to raise_error Puppet::Error }
      end

      context 'when specifying additional arguments' do
        let(:title) { 'foo.example.com' }
        let(:params) { { additional_args: ['--foo bar', '--baz quux'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command "letsencrypt --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com' --foo bar --baz quux" }
      end

      describe 'when specifying custom environment variables' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: ['FOO=bar', 'FIZZ=buzz'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_environment(['FOO=bar', 'FIZZ=buzz']) }
      end

      context 'with custom environment variables and manage_cron' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: ['FOO=bar', 'FIZZ=buzz'], manage_cron: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_content "#!/bin/sh\nexport FOO=bar\nexport FIZZ=buzz\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n" }
      end

      context 'with manage cron and cron_output=suppress' do \
        let(:title) { 'foo.example.com' }
        let(:params) do
          { manage_cron: true,
            cron_output: 'suppress' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command('"/var/lib/puppet/letsencrypt/renew-foo.example.com.sh"').with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com' > /dev/null 2>&1\n") }
      end

      context 'with manage cron and cron_output=log' do \
        let(:title) { 'foo.example.com' }
        let(:params) do
          { manage_cron: true,
            cron_output: 'log' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command('"/var/lib/puppet/letsencrypt/renew-foo.example.com.sh"').with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com' 2>&1 | logger -t letsencrypt-renew\n") }
      end

      context 'with manage cron and custom day of month' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          { manage_cron: true,
            cron_monthday: [1, 15] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with(monthday: [1, 15]).with_ensure('present') }
        it { is_expected.to contain_file('/var/lib/puppet/letsencrypt/renew-foo.example.com.sh').with_ensure('file').with_content("#!/bin/sh\nletsencrypt --keep-until-expiring --text --agree-tos --non-interactive certonly --key-type rsa --rsa-key-size 4096 -a standalone --cert-name 'foo.example.com' -d 'foo.example.com'\n") }
      end

      context 'with custom config_dir' do
        let(:title) { 'foo.example.com' }
        let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com', config_dir => '/foo/bar/baz', package_command => 'letsencrypt'}" }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/foo/bar/baz').with_ensure('directory') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_unless(['test ! -f /usr/local/sbin/letsencrypt-domain-validation', '/usr/local/sbin/letsencrypt-domain-validation /foo/bar/baz/live/foo.example.com/cert.pem \'foo.example.com\'']) }
      end

      context 'on FreeBSD', if: facts[:os]['name'] == 'FreeBSD' do
        let(:title) { 'foo.example.com' }
        let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com'}" }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command %r{^certbot} }
        it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com') }
        it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini server https://acme-v02.api.letsencrypt.org/directory') }
        it { is_expected.to contain_file('/usr/local/etc/letsencrypt').with_ensure('directory') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_unless(['test ! -f /usr/local/sbin/letsencrypt-domain-validation', '/usr/local/sbin/letsencrypt-domain-validation /usr/local/etc/letsencrypt/live/foo.example.com/cert.pem \'foo.example.com\'']) }
      end

      context 'with custom commands in init.pp' do
        let(:title) { 'foo.example.com' }
        let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com', certonly_pre_hook_commands => ['foo'], certonly_post_hook_commands => ['bar'], certonly_deploy_hook_commands => ['baz']}" }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_letsencrypt__hook('foo.example.com-pre') }
        it { is_expected.to contain_letsencrypt__hook('foo.example.com-post') }
        it { is_expected.to contain_letsencrypt__hook('foo.example.com-deploy') }
        it { is_expected.to have_letsencrypt__hook_resource_count(3) }
      end
    end
  end
end
