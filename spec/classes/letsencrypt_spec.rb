require 'spec_helper'

describe 'letsencrypt' do
  ['Debian', 'RedHat'].each do |osfamily|
    context "on #{osfamily} based operating systems" do
      let(:facts) { { osfamily: osfamily } }

      context 'when specifying an email address with the email parameter' do
        let(:params) { additional_params.merge(default_params) }
        let(:default_params) { { email: 'foo@example.com' } }
        let(:additional_params) { { } }

        describe 'with defaults' do
          it { is_expected.to compile }

          it 'should contain the correct resources' do
            is_expected.to contain_vcsrepo('/opt/letsencrypt').with({
              source: 'git://github.com/letsencrypt/letsencrypt.git',
              revision: 'v0.1.0'
            })

            is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com')
            is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory')
            is_expected.to contain_exec('initialize letsencrypt').with_command('/opt/letsencrypt/letsencrypt-auto -h')
            is_expected.to contain_class('letsencrypt::config').that_comes_before('Exec[initialize letsencrypt]')
            is_expected.to contain_package('python')
            is_expected.to contain_package('git')
          end
        end

        describe 'with custom path' do
          let(:additional_params) { { path: '/usr/lib/letsencrypt' } }
          it { is_expected.to contain_vcsrepo('/usr/lib/letsencrypt') }
          it { is_expected.to contain_exec('initialize letsencrypt').with_command('/usr/lib/letsencrypt/letsencrypt-auto -h') }
        end

        describe 'with custom repo' do
          let(:additional_params) { { repo: 'git://foo.com/letsencrypt.git' } }
          it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_source('git://foo.com/letsencrypt.git') }
        end

        describe 'with custom version' do
          let(:additional_params) { { version: 'foo' } }
          it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_revision('foo') }
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

        describe 'with manage_dependencies set to false' do
          let(:additional_params) { { manage_dependencies: false } }
          it 'should not contain the dependencies' do
            is_expected.not_to contain_package('git')
            is_expected.not_to contain_package('python')
          end
        end

        context 'when not agreeing to the TOS' do
          let(:params) { { agree_tos: false } }
          it { is_expected.to raise_error Puppet::Error, /You must agree to the Let's Encrypt Terms of Service/ }
        end
      end

      context 'when specifying an email in $config' do
        let(:params) { { config: { 'email' => 'foo@example.com' } } }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
      end

      context 'when not specifying the email parameter or an email key in $config' do
        context 'with unsafe_registration set to false' do
          it { is_expected.to raise_error Puppet::Error, /Please specify an email address/ }
        end

        context 'with unsafe_registration set to true' do
          let(:params) {{ unsafe_registration: true }}
          it { is_expected.not_to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
          it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini register-unsafely-without-email true') }
        end
      end
    end
  end

  context 'on unsupported operating systems' do
    let(:facts) { { osfamily: 'Darwin' } }
    it 'should fail' do
      is_expected.to raise_error Puppet::Error, /The letsencrypt module does not support Darwin/
    end
  end
end
