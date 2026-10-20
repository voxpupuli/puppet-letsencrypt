# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::suse::certificate' do
  let(:title) { 'example.com' }

  let(:facts) do
    {
      os: {
        family: 'Suse',
        name: 'SLES',
        release: {
          full: '15.5',
          major: '15',
        },
      },
      service_provider: 'systemd',
      puppet_vardir: '/opt/puppetlabs/puppet/cache',
    }
  end

  let(:pre_condition) do
    <<-PUPPET
      class { 'letsencrypt::suse':
        email => 'foo@example.com',
      }
    PUPPET
  end

  context 'with the default DNS-01 plugin path' do
    let(:params) { {} }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('letsencrypt::plugin::dns_azure').with(config_path: '/etc/letsencrypt/azure.ini') }
    it { is_expected.to contain_letsencrypt__certonly('example.com').with(plugin: 'dns-azure') }
    it { is_expected.to contain_letsencrypt__certonly('example.com').with_additional_args([]) }
    it { is_expected.to contain_exec('letsencrypt-suse-certificate-preflight-example.com') }
  end

  context 'with custom azure config path and preflight disabled' do
    let(:params) do
      {
        azure_config_file: '/opt/letsencrypt/custom-azure.ini',
        validate_azure_config: false,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('letsencrypt::plugin::dns_azure').with(config_path: '/opt/letsencrypt/custom-azure.ini') }
    it { is_expected.to contain_letsencrypt__certonly('example.com').with(plugin: 'dns-azure') }
    it { is_expected.not_to contain_exec('letsencrypt-suse-certificate-preflight-example.com') }
  end

  context 'with the HTTP-01 plugin' do
    let(:params) do
      {
        plugin: 'http-01',
        webroot_paths: ['/var/www/example.com'],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_letsencrypt__certonly('example.com').with(plugin: 'webroot', webroot_paths: ['/var/www/example.com']) }
    it { is_expected.not_to contain_class('letsencrypt::plugin::dns_azure') }
    it { is_expected.not_to contain_exec('letsencrypt-suse-certificate-preflight-example.com') }
  end

  context 'with HTTP-01 but no webroot paths' do
    let(:params) { { plugin: 'http-01' } }

    it { is_expected.to raise_error(Puppet::Error, %r{webroot_paths.*must be specified}) }
  end

  context 'on SLES outside supported service pack range' do
    let(:facts) do
      {
        os: {
          family: 'Suse',
          name: 'SLES',
          release: {
            full: '15.3',
            major: '15',
          },
        },
        service_provider: 'systemd',
        puppet_vardir: '/opt/puppetlabs/puppet/cache',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{supports SLES releases 15.4 through 15.7}) }
  end

  context 'on non-SLES facts' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'Rocky',
          release: {
            full: '9.3',
            major: '9',
          },
        },
        service_provider: 'systemd',
        puppet_vardir: '/opt/puppetlabs/puppet/cache',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{only supported on SLES systems}) }
  end
end
