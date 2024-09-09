# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::plugin::apache' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { {} }
      let(:pre_condition) do
        <<-PUPPET
        class { 'letsencrypt':
          email => 'foo@example.com',
        }
        PUPPET
      end
      let(:package_name) do
        'python3-certbot-apache'
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        it 'installs the certbot apache plugin' do
          is_expected.to contain_class('letsencrypt::plugin::apache')
          is_expected.to contain_package(package_name).with_ensure('installed')
        end

        describe 'with manage_package => false' do
          let(:params) { super().merge(manage_package: false, package_name: 'apache-package') }

          it { is_expected.not_to contain_package('apache-package') }
        end
      end
    end
  end
end
