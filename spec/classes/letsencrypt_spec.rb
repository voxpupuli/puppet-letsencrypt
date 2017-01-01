require 'spec_helper'

describe 'letsencrypt' do
  { 'Debian' => '9.0', 'RedHat' => '7.2' }.each do |osfamily, osversion|
    context "on #{osfamily} based operating systems" do
      let(:facts) { { osfamily: osfamily, operatingsystem: osfamily, operatingsystemrelease: osversion, operatingsystemmajrelease: osversion.split('.').first, path: '/usr/bin' } }

      context 'when specifying an email address with the email parameter' do
        let(:params) { additional_params.merge(default_params) }
        let(:default_params) { { email: 'foo@example.com' } }
        let(:additional_params) { {} }

        describe 'with defaults' do
          it { is_expected.to compile }

          epel = if osfamily == 'RedHat'
                   true
                 else
                   false
                 end

          it 'contains the correct resources' do
            is_expected.to contain_class('letsencrypt::install').with(configure_epel: epel,
                                                                      manage_install: true,
                                                                      manage_dependencies: true,
                                                                      repo: 'https://github.com/letsencrypt/letsencrypt.git',
                                                                      version: 'v0.9.3').that_notifies('Exec[initialize letsencrypt]')

            is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com')
            is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory')
            is_expected.to contain_exec('initialize letsencrypt')
            is_expected.to contain_class('letsencrypt::config').that_comes_before('Exec[initialize letsencrypt]')
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
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini foo bar') }
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

        context 'when not agreeing to the TOS' do
          let(:params) { { agree_tos: false } }
          it { is_expected.to raise_error Puppet::Error, %r{You must agree to the Let's Encrypt Terms of Service} }
        end
      end

      context 'when specifying an email in $config' do
        let(:params) { { config: { 'email' => 'foo@example.com' } } }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
      end

      context 'when not specifying the email parameter or an email key in $config' do
        context 'with unsafe_registration set to false' do
          it { is_expected.to raise_error Puppet::Error, %r{Please specify an email address} }
        end

        context 'with unsafe_registration set to true' do
          let(:params) { { unsafe_registration: true } }
          it { is_expected.not_to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini register-unsafely-without-email true') }
        end
      end
    end
  end

  context 'on unknown operating systems' do
    let(:facts) { { osfamily: 'Darwin', operatingsystem: 'Darwin', operatingsystemrelease: '14.5.0', operatingsystemmajrelease: '14', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
      end
    end
  end

  context 'on EL7 operating system' do
    let(:facts) { { osfamily: 'RedHat', operatingsystem: 'RedHat', operatingsystemrelease: '7.2', operatingsystemmajrelease: '7', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('epel').that_comes_before('Package[letsencrypt]')
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
        is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
        is_expected.to contain_package('letsencrypt').with(name: 'certbot')
      end
    end
  end

  context 'on EL6 operating system' do
    let(:facts) { { osfamily: 'RedHat', operatingsystem: 'RedHat', operatingsystemrelease: '6.7', operatingsystemmajrelease: '6', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
        is_expected.not_to contain_class('epel').that_comes_before('Package[letsencrypt]')
        is_expected.not_to contain_class('letsencrypt::install').with(install_method: 'package')
      end
    end
  end

  context 'on Debian 8 operating system' do
    let(:facts) { { osfamily: 'Debian', operatingsystem: 'Debian', operatingsystemrelease: '8.0', operatingsystemmajrelease: '8.0', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
      end
    end
  end

  context 'on Debian 9 operating system' do
    let(:facts) { { osfamily: 'Debian', operatingsystem: 'Debian', operatingsystemrelease: '9.0', operatingsystemmajrelease: '9.0', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
      end
    end
  end

  context 'on Ubuntu 14.04 operating system' do
    let(:facts) { { osfamily: 'Debian', operatingsystem: 'Ubuntu', operatingsystemrelease: '14.04', operatingsystemmajrelease: '14.04', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'vcs')
      end
    end
  end

  context 'on Ubuntu 16.04 operating system' do
    let(:facts) { { osfamily: 'Debian', operatingsystem: 'Ubuntu', operatingsystemrelease: '16.04', operatingsystemmajrelease: '16.04', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'package')
      end
    end
  end

  context 'on Gentoo operating system' do
    let(:facts) { { osfamily: 'Gentoo', operatingsystem: 'Gentoo', operatingsystemrelease: '4.4.6-r2', operatingsystemmajrelease: '4', path: '/usr/bin' } }
    let(:params) { { email: 'foo@example.com' } }

    describe 'with defaults' do
      it { is_expected.to compile }

      it 'contains the correct resources' do
        is_expected.to contain_class('letsencrypt::install').with(install_method: 'package').with(package_name: 'app-crypt/certbot')
        is_expected.to contain_class('letsencrypt').with(package_command: 'certbot')
        is_expected.to contain_package('letsencrypt').with(name: 'app-crypt/certbot')
      end
    end
  end
end
