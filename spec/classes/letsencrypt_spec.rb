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

          epel = facts[:osfamily] == 'RedHat'

          it 'contains the correct resources' do
            is_expected.to contain_class('letsencrypt::install').with(configure_epel: epel,
                                                                      manage_install: true,
                                                                      manage_dependencies: true,
                                                                      repo: 'https://github.com/certbot/certbot.git',
                                                                      version: 'v0.9.3').that_notifies('Exec[initialize letsencrypt]')
            is_expected.to contain_exec('initialize letsencrypt')
            is_expected.to contain_class('letsencrypt::config').that_comes_before('Exec[initialize letsencrypt]')

            case facts[:operatingsystem]
            when 'FreeBSD'
              is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini email foo@example.com')
              is_expected.to contain_ini_setting('/usr/local/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory')
            else
              is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com')
              is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory')
            end

            if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7'
              is_expected.to contain_class('epel').that_comes_before('Package[letsencrypt]')
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'certbot')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'Debian'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '14.04'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'Ubuntu'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'Gentoo'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package').with(package_name: 'app-crypt/certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'app-crypt/certbot')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'OpenBSD'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package').with(package_name: 'certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'certbot')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            elsif facts[:operatingsystem] == 'FreeBSD'
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'package').with(package_name: 'py27-certbot')
              is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
              is_expected.to contain_package('letsencrypt').with(name: 'py27-certbot')
              is_expected.to contain_file('/usr/local/etc/letsencrypt').with(ensure: 'directory')
            else
              is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
              is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory')
            end
          end
        end

        describe 'with custom path' do
          let(:additional_params) { { path: '/usr/lib/letsencrypt', install_method: 'vcs' } }

          it { is_expected.to contain_class('letsencrypt::install').with_path('/usr/lib/letsencrypt') }
          it { is_expected.to contain_exec('initialize letsencrypt').with_command('/usr/lib/letsencrypt/letsencrypt-auto -h') }
        end

        describe 'with custom environment variables' do
          let(:additional_params) { { environment: ['FOO=bar', 'FIZZ=buzz'] } }

          it { is_expected.to contain_exec('initialize letsencrypt').with_environment(['VENV_PATH=/opt/letsencrypt/.venv', 'FOO=bar', 'FIZZ=buzz']) }
        end

        describe 'with custom repo' do
          let(:additional_params) { { repo: 'git://foo.com/letsencrypt.git' } }

          it { is_expected.to contain_class('letsencrypt::install').with_repo('git://foo.com/letsencrypt.git') }
        end

        describe 'with custom version' do
          let(:additional_params) { { version: 'foo' } }

          it { is_expected.to contain_class('letsencrypt::install').with_path('/opt/letsencrypt').with_version('foo') }
        end

        describe 'with custom package_ensure' do
          let(:additional_params) { { package_ensure: '0.3.0-1.el7' } }

          it { is_expected.to contain_class('letsencrypt::install').with_package_ensure('0.3.0-1.el7') }
        end

        describe 'with custom config file' do
          let(:additional_params) { { config_file: '/etc/letsencrypt/custom_config.ini' } }

          it { is_expected.to contain_ini_setting('/etc/letsencrypt/custom_config.ini server https://acme-v01.api.letsencrypt.org/directory') }
        end

        describe 'with custom config' do
          let(:additional_params) { { config: { 'foo' => 'bar' } } }

          case facts[:operatingsystem]
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

        describe 'with install_method => package' do
          let(:additional_params) { { install_method: 'package', package_command: 'letsencrypt' } }

          it { is_expected.to contain_class('letsencrypt::install').with_install_method('package') }
          it { is_expected.to contain_exec('initialize letsencrypt').with_command('letsencrypt -h') }
        end

        describe 'with install_method => vcs' do
          let(:additional_params) { { install_method: 'vcs' } }

          it { is_expected.to contain_class('letsencrypt::install').with_install_method('vcs') }
          it { is_expected.to contain_exec('initialize letsencrypt').with_command('/opt/letsencrypt/letsencrypt-auto -h') }
        end

        describe 'with custom config directory' do
          let(:additional_params) { { config_dir: '/foo/bar/baz' } }

          it { is_expected.to contain_file('/foo/bar/baz').with(ensure: 'directory') }
        end

        context 'when not agreeing to the TOS' do
          let(:params) { { agree_tos: false } }

          it { is_expected.to raise_error Puppet::Error, %r{You must agree to the Let's Encrypt Terms of Service} }
        end
      end

      context 'when specifying an email in $config' do
        let(:params) { { config: { 'email' => 'foo@example.com' } } }

        it { is_expected.to compile.with_all_deps }
        case facts[:operatingsystem]
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

          case facts[:operatingsystem]
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
