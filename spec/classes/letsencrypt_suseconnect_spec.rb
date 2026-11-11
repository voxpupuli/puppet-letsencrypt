# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::suseconnect' do
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
    }
  end

  context 'with defaults' do
    let(:params) { {} }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_file('/var/lib/letsencrypt/suseconnect') }
    it { is_expected.not_to contain_exec('letsencrypt-add-packman-repo') }
  end

  context 'with manage enabled and SUSEConnect products' do
    let(:params) do
      {
        manage: true,
        products: [
          'sle-module-python3/15.5/x86_64',
        ],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/var/lib/letsencrypt/suseconnect').with(ensure: 'directory') }

    it do
      is_expected.to contain_exec('letsencrypt-suseconnect-sle-module-python3/15.5/x86_64').with(
        command: '/bin/sh -c "/usr/sbin/SUSEConnect -p sle-module-python3/15.5/x86_64 && touch /var/lib/letsencrypt/suseconnect/sle-module-python3_15.5_x86_64.enabled"',
      )
    end
  end

  context 'with manage enabled and no products/repo' do
    let(:params) do
      {
        manage: true,
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{Set at least one SUSEConnect product or a Packman repo}) }
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
      }
    end

    let(:params) { {} }

    it { is_expected.to raise_error(Puppet::Error, %r{only supported on SLES systems}) }
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
      }
    end

    let(:params) { {} }

    it { is_expected.to raise_error(Puppet::Error, %r{supports SLES releases 15.4 through 15.7}) }
  end
end
