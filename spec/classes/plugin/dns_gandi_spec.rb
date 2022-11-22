# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::plugin::dns_gandi' do
  on_supported_os.each do |os, facts|
    next unless supported_os_gandi(facts[:os])

    context "on #{os} based operating systems" do
      let(:facts) { facts }
      let(:params) { { 'api_key' => 'dummy-gandi-api-token' } }
      let(:pre_condition) do
        <<-PUPPET
        class { 'letsencrypt':
          email => 'foo@example.com',
        }
        PUPPET
      end

      context 'with required parameters' do
        it do
          if package_name.nil?
            is_expected.not_to compile
          else
            is_expected.to compile.with_all_deps
          end
        end

        describe 'with manage_package => true' do
          let(:params) { super().merge(manage_package: true) }

          it do
            if package_name.nil?
              is_expected.to compile.and_raise_error(%r{/expects a value for parameter 'package_name'/})
            else
              is_expected.to contain_class('letsencrypt::plugin::dns_gandi').with_package_name(package_name)
              is_expected.to contain_package(package_name).with_ensure('installed')
            end
          end
        end

        describe 'with manage_package => false' do
          let(:params) { super().merge(manage_package: false, package_name: 'dns-gandi-package') }

          it { is_expected.not_to contain_package('dns-gandi-package') }
        end
      end
    end
  end
end
