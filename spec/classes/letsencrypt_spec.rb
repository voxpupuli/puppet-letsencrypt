require 'spec_helper'

describe 'letsencrypt' do
  context 'on supported operating systems' do
    let(:facts) { { osfamily: 'Debian' } }
    it { is_expected.to compile }

    describe 'with defaults' do
      it 'should contain the correct resources' do
        is_expected.to contain_vcsrepo('/opt/letsencrypt').with({
          source: 'git://github.com/letsencrypt/letsencrypt.git',
          revision: 'v0.1.0'
        })

        is_expected.to contain_exec('initialize letsencrypt').with_command('/opt/letsencrypt/letsencrypt-auto --agree-tos -h')
        is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory')
        is_expected.to contain_package('python')
        is_expected.to contain_package('git')
      end
    end

    describe 'with custom path' do
      let(:params) { { path: '/usr/lib/letsencrypt' } }

      it { is_expected.to contain_vcsrepo('/usr/lib/letsencrypt') }
      it { is_expected.to contain_exec('initialize letsencrypt').with_command('/usr/lib/letsencrypt/letsencrypt-auto --agree-tos -h') }
    end

    describe 'with custom repo' do
      let(:params) { { repo: 'git://foo.com/letsencrypt.git' } }
      it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_source('git://foo.com/letsencrypt.git') }
    end

    describe 'with custom version' do
      let(:params) { { version: 'foo' } }
      it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_revision('foo') }
    end

    describe 'with custom config file' do
      let(:params) { { config_file: '/etc/letsencrypt/custom_config.ini' } }
      it { is_expected.to contain_ini_setting('/etc/letsencrypt/custom_config.ini server https://acme-v01.api.letsencrypt.org/directory') }
    end

    describe 'with custom config' do
      let(:params) { { config: { 'foo' => 'bar' } } }
      it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini foo bar') }
    end

    describe 'with manage_config set to false' do
      let(:params) { { manage_config: false } }
      it { is_expected.not_to contain_ini_setting('/etc/letsencrypt/cli.ini server https://acme-v01.api.letsencrypt.org/directory') }
    end

    describe 'with manage_dependencies set to false' do
      let(:params) { { manage_dependencies: false } }
      it 'should not contain the dependencies' do
        is_expected.not_to contain_package('git')
        is_expected.not_to contain_package('python')
      end
    end
  end

  context 'on not supported operating systems' do
    let(:facts) { { osfamily: 'RedHat' } }
    it 'should fail' do
      is_expected.to raise_error Puppet::Error, /supports Debian-based operating systems/
    end
  end
end
