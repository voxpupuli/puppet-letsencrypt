# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::suse' do
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

  let(:params) do
    {
      email: 'foo@example.com',
    }
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('letsencrypt').with(email: 'foo@example.com') }

  context 'with suseconnect management enabled' do
    let(:params) do
      super().merge(
        manage_suseconnect: true,
        suseconnect_products: ['sle-module-python3/15.5/x86_64'],
      )
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('letsencrypt::suseconnect').with(manage: true) }
    it { is_expected.to contain_class('letsencrypt::suseconnect').that_comes_before('Class[letsencrypt]') }
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
