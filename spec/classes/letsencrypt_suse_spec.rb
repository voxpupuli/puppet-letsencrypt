# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt' do
  let(:params) do
    {
      email: 'foo@example.com',
      renew_cron_ensure: 'present',
      renew_disable_distro_cron: true,
    }
  end

  shared_examples 'suse family certbot defaults' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('letsencrypt::install').with(package_name: 'certbot') }
    it { is_expected.to contain_package('letsencrypt').with(name: 'certbot', ensure: 'installed') }
    it { is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory') }
    it { is_expected.to contain_ini_setting('/etc/letsencrypt/cli.ini email foo@example.com') }
    it { is_expected.to contain_service('certbot.timer').with(ensure: 'stopped', enable: false) }
  end

  context 'on SLES 15.4 (primary test target lower bound)' do
    let(:facts) do
      {
        os: {
          family: 'Suse',
          name: 'SLES',
          release: {
            full: '15.4',
            major: '15',
          },
        },
        service_provider: 'systemd',
        puppet_vardir: '/opt/puppetlabs/puppet/cache',
      }
    end

    it_behaves_like 'suse family certbot defaults'
  end

  context 'on SLES 15.7 (primary test target upper bound)' do
    let(:facts) do
      {
        os: {
          family: 'Suse',
          name: 'SLES',
          release: {
            full: '15.7',
            major: '15',
          },
        },
        service_provider: 'systemd',
        puppet_vardir: '/opt/puppetlabs/puppet/cache',
      }
    end

    it_behaves_like 'suse family certbot defaults'
  end
end
