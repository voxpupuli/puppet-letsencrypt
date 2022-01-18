# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::install' do
  on_supported_os.each do |os, facts|
    let(:params) { default_params.merge(additional_params) }
    let(:default_params) do
      {
        configure_epel: false,
        package_ensure: 'installed',
        package_name: 'letsencrypt'
      }
    end
    let(:additional_params) { {} }

    context "on #{os} based operating systems" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it 'contains the correct resources' do
        is_expected.to contain_package('letsencrypt').with_ensure('installed')
      end

      describe 'with package_ensure => 0.3.0-1.el7' do
        let(:additional_params) { { package_ensure: '0.3.0-1.el7' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('letsencrypt').with_ensure('0.3.0-1.el7') }
      end

      case facts[:osfamily]
      when 'RedHat'
        describe 'with configure_epel => true' do
          let(:additional_params) { { configure_epel: true } }

          it { is_expected.to compile.with_all_deps }

          it 'contains the correct resources' do
            is_expected.to contain_class('epel')
            is_expected.to contain_package('letsencrypt').that_requires('Class[epel]')
          end
        end
      end
    end
  end
end
