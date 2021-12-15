require 'spec_helper'

describe 'letsencrypt::plugin::nginx' do
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
        if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '7'
          'python2-certbot-nginx'
        else
          'python3-certbot-nginx'
        end
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it 'installs the certbot nginx plugin' do
          is_expected.to contain_class('letsencrypt::plugin::nginx')
          is_expected.to contain_package(package_name).with_ensure('installed')
        end

        describe 'with manage_package => false' do
          let(:params) { super().merge(manage_package: false, package_name: 'nginx-package') }

          it { is_expected.not_to contain_package('nginx-package') }
        end
      end
    end
  end
end
