# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'when specifying an email address with the email parameter' do
        let(:params) { additional_params.merge(default_params) }
        let(:default_params) { { email: 'foo@example.com' } }
        let(:additional_params) { {} }

        describe 'with defaults' do
          it { is_expected.to compile }

          epel = facts['os']['family'] == 'RedHat' && facts['os']['name'] != 'Fedora'
          it 'contains the correct resources' do
            is_expected.to contain_class('letsencrypt::install').
              with(configure_epel: epel).
              that_comes_before('Class[letsencrypt::renew]')
            is_expected.to contain_class('letsencrypt::config')
            is_expected.to contain_class('letsencrypt::renew').
              with(pre_hook_commands: [],
                   post_hook_commands: [],
                   deploy_hook_commands: [],
                   additional_args: [],
                   cron_ensure: 'absent',
                   cron_monthday: ['*'])
            is_expected.to contain_cron('letsencrypt-renew').with_ensure('absent')

            if facts['os']['family'] == 'FreeBSD'
              is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com')
              is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini server https://acme-v02.api.letsencrypt.org/directory')
              is_expected.to contain_file('letsencrypt-renewal-hooks-puppet').
                with(ensure: 'directory',
                     path: '/usr/local/etc/letsencrypt/renewal-hooks-puppet',
                     owner: 'root',
                     group: 0,
                     mode: '0755',
                     recurse: true,
                     purge: true)
            else
              is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com')
              is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v02.api.letsencrypt.org/directory')
              is_expected.to contain_file('letsencrypt-renewal-hooks-puppet').with_path('/etc/letsencrypt/renewal-hooks-puppet')
            end

            if facts['os']['family'] == 'RedHat'
              if epel
                is_expected.to contain_class('epel').that_comes_before('Package[letsencrypt]')
              else
                is_expected.not_to contain_class('epel')
              end
              is_expected.to contain_class('letsencrypt::install').with(package_name: 'certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'certbot').with_ensure('installed')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts['os']['family'] == 'Debian'
              is_expected.to contain_class('letsencrypt::install').with(package_name: 'certbot')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts['os']['name'] == 'Gentoo'
              is_expected.to contain_class('letsencrypt::install').with(package_name: 'app-crypt/certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'app-crypt/certbot').with_ensure('installed')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts['os']['name'] == 'OpenBSD'
              is_expected.to contain_class('letsencrypt::install').with(package_name: 'certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'certbot').with_ensure('installed')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts['os']['name'] == 'FreeBSD'
              is_expected.to contain_class('letsencrypt::install').with(package_name: 'py311-certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'py311-certbot').with_ensure('installed')
              is_expected.to contain_file('/usr/local/etc/letsencrypt').with(ensure: 'directory')
            else
              is_expected.to contain_class('letsencrypt::install')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            end
          end
        end

        describe 'with custom package_ensure' do
          let(:additional_params) { { package_ensure: '0.3.0-1.el7' } }

          it { is_expected.to contain_class('letsencrypt::install').with_package_ensure('0.3.0-1.el7') }
        end

        describe 'with custom config file' do
          let(:additional_params) { { config_file: '/etc/letsencrypt/custom_config.ini' } }

          it { is_expected.to contain_ini_setting('/etc/letsencrypt/custom_config.ini server https://acme-v02.api.letsencrypt.org/directory') }
        end

        describe 'with custom config' do
          let(:additional_params) { { config: { 'foo' => 'bar' } } }

          case facts['os']['name']
          when 'FreeBSD'
            it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini foo bar') }
          else
            it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini foo bar') }
          end
        end

        describe 'with manage_config set to false' do
          let(:additional_params) { { manage_config: false } }

          it { is_expected.not_to contain_class('letsencrypt::config') }
        end

        describe 'with manage_install set to false' do
          let(:additional_params) { { manage_install: false } }

          it { is_expected.not_to contain_class('letsencrypt::install') }
        end

        describe 'with custom config directory' do
          let(:additional_params) { { config_dir: '/foo/bar/baz' } }

          it { is_expected.to contain_file('/foo/bar/baz').with(ensure: 'directory') }
        end

        describe 'with list of certificates' do
          let(:additional_params) do
            { certificates: {
              'foo' => { 'domains' => %w[lth0edae4nzfq895 nsgqqm4mbw257t9i] },
              'a' => { 'environment' => %w[ABC=y9jby5nmfgmstnbk DFE=y00lt0fh1vj2amjx] }
            } }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_letsencrypt__certonly('foo').with_domains(%w[lth0edae4nzfq895 nsgqqm4mbw257t9i]) }
          it { is_expected.to contain_letsencrypt__certonly('a').with_environment(%w[ABC=y9jby5nmfgmstnbk DFE=y00lt0fh1vj2amjx]) }
        end

        context 'when not agreeing to the TOS' do
          let(:params) { { agree_tos: false } }

          it { is_expected.to raise_error Puppet::Error, %r{You must agree to the Let's Encrypt Terms of Service} }
        end

        context 'with renew' do
          describe 'pre hook' do
            let(:additional_params) { { config_dir: '/etc/letsencrypt', renew_pre_hook_commands: ['FooBar'] } }

            it { is_expected.to contain_letsencrypt__hook('renew-pre').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/renew-pre.sh') }
          end

          describe 'post hook' do
            let(:additional_params) { { config_dir: '/etc/letsencrypt', renew_post_hook_commands: ['FooBar'] } }

            it { is_expected.to contain_letsencrypt__hook('renew-post').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/renew-post.sh') }
          end

          describe 'deploy hook' do
            let(:additional_params) { { config_dir: '/etc/letsencrypt', renew_deploy_hook_commands: ['FooBar'] } }

            it { is_expected.to contain_letsencrypt__hook('renew-deploy').with_hook_file('/etc/letsencrypt/renewal-hooks-puppet/renew-deploy.sh') }
          end

          describe 'renew_cron_ensure' do
            let(:additional_params) do
              { renew_cron_ensure: 'present',
                renew_cron_hour: 0,
                renew_cron_minute: 0 }
            end

            it do
              is_expected.to contain_cron('letsencrypt-renew').
                with(ensure: 'present',
                     command: 'certbot renew -q',
                     hour: 0,
                     minute: 0,
                     monthday: '*')
            end
          end

          describe 'renew_cron_ensure and renew_cron_monthday' do
            let(:additional_params) { { renew_cron_ensure: 'present', renew_cron_monthday: [1, 15] } }

            it { is_expected.to contain_cron('letsencrypt-renew').with_ensure('present').with_monthday([1, 15]) }
          end

          describe 'renew_cron_ensure and hooks' do
            let(:additional_params) do
              { config_dir: '/etc/letsencrypt',
                renew_cron_ensure: 'present',
                renew_pre_hook_commands: ['PreBar'],
                renew_post_hook_commands: ['PostBar'],
                renew_deploy_hook_commands: ['DeployBar'] }
            end

            it do
              is_expected.to contain_cron('letsencrypt-renew').
                with(ensure: 'present',
                     command: 'certbot renew -q --pre-hook "/etc/letsencrypt/renewal-hooks-puppet/renew-pre.sh" --post-hook "/etc/letsencrypt/renewal-hooks-puppet/renew-post.sh" --deploy-hook "/etc/letsencrypt/renewal-hooks-puppet/renew-deploy.sh"')
            end
          end

          describe 'renew_cron_ensure and additional args' do
            let(:additional_params) do
              { renew_cron_ensure: 'present',
                renew_additional_args: ['AdditionalBar'] }
            end

            it do
              is_expected.to contain_cron('letsencrypt-renew').
                with(ensure: 'present',
                     command: 'certbot renew -q AdditionalBar')
            end
          end

          describe 'renew_cron_ensure and environment' do
            let(:additional_params) do
              { renew_cron_ensure: 'present',
                renew_cron_environment: ['PATH=/usr/sbin'] }
            end

            it do
              is_expected.to contain_cron('letsencrypt-renew').
                with(ensure: 'present',
                     command: 'certbot renew -q',
                     environment: ['PATH=/usr/sbin'])
            end
          end
        end
      end

      context 'when specifying an email in $config' do
        let(:params) { { config: { 'email' => 'foo@example.com' } } }

        it { is_expected.to compile.with_all_deps }

        case facts['os']['name']
        when 'FreeBSD'
          it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com') }
        else
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
        end
      end

      context 'when not specifying the email parameter or an email key in $config' do
        context 'with unsafe_registration set to false' do
          it { is_expected.to raise_error Puppet::Error, %r{Please specify an email address} }
        end

        context 'with unsafe_registration set to true' do
          let(:params) { { unsafe_registration: true } }

          case facts['os']['name']
          when 'FreeBSD'
            it { is_expected.not_to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com') }
            it { is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini register-unsafely-without-email true') }
          else
            it { is_expected.not_to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
            it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini register-unsafely-without-email true') }
          end
        end
      end
    end
  end
end
