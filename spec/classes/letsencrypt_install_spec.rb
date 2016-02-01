require 'spec_helper'

describe 'letsencrypt::install' do
  let(:params) { default_params.merge(additional_params) }
  let(:default_params) do
    {
      configure_epel: false,
      manage_install: true,
      manage_dependencies: true,
      path: '/opt/letsencrypt',
      repo: 'git://github.com/letsencrypt/letsencrypt.git',
      version: 'v0.1.0',
    }
  end
  let(:additional_params) { { } }

  describe 'with install_method => package' do
    let(:additional_params) { { install_method: 'package' } }

    it { is_expected.to compile }

    it 'should contain the correct resources' do
      is_expected.not_to contain_vcsrepo('/opt/letsencrypt')
      is_expected.not_to contain_package('python')
      is_expected.not_to contain_package('git')

      is_expected.to contain_package('letsencrypt').with_ensure('installed')
    end

    describe 'with configure_epel => true' do
      let(:additional_params) { { install_method: 'package', configure_epel: true } }

      it { is_expected.to compile }

      it 'should contain the correct resources' do
        is_expected.to contain_class('epel')
        is_expected.to contain_package('letsencrypt').that_requires('Class[epel]')
      end
    end
  end

  describe 'with install_method => vcs' do
    let(:additional_params) { { install_method: 'vcs' } }

    it { is_expected.to compile }

    it 'should contain the correct resources' do
      is_expected.to contain_vcsrepo('/opt/letsencrypt').with({
        source: 'git://github.com/letsencrypt/letsencrypt.git',
        revision: 'v0.1.0'
      })
      is_expected.to contain_package('python')
      is_expected.to contain_package('git')

      is_expected.not_to contain_package('letsencrypt')
    end

    describe 'with custom path' do
      let(:additional_params) { { install_method: 'vcs', path: '/usr/lib/letsencrypt' } }
      it { is_expected.to contain_vcsrepo('/usr/lib/letsencrypt') }
    end

    describe 'with custom repo' do
      let(:additional_params) { { install_method: 'vcs', repo: 'git://foo.com/letsencrypt.git' } }
      it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_source('git://foo.com/letsencrypt.git') }
    end

    describe 'with custom version' do
      let(:additional_params) { { install_method: 'vcs', version: 'foo' } }
      it { is_expected.to contain_vcsrepo('/opt/letsencrypt').with_revision('foo') }
    end

    describe 'with manage_dependencies set to false' do
      let(:additional_params) { { install_method: 'vcs', manage_dependencies: false } }
      it 'should not contain the dependencies' do
        is_expected.not_to contain_package('git')
        is_expected.not_to contain_package('python')
      end
    end
  end
end
