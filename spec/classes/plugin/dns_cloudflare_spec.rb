# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::plugin::dns_cloudflare' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} based operating systems" do
      let(:facts) { os_facts }
      let(:params) { { 'api_token' => 'dummy-cloudflare-api-token' } }
      let(:pre_condition) do
        <<-PUPPET
        class { 'letsencrypt':
          email => 'foo@example.com',
        }
        PUPPET
      end
      let(:package_name) do
        osname = facts[:os]['name']
        osrelease = facts[:os]['release']['major']
        osfull = "#{osname}-#{osrelease}"
        if %w[RedHat-7 CentOS-7].include?(osfull)
          'python2-certbot-dns-cloudflare'
        elsif %w[Debian RedHat].include?(facts[:os]['family'])
          'python3-certbot-dns-cloudflare'
        elsif %w[FreeBSD].include?(facts[:os]['family'])
          'py311-certbot-dns-cloudflare'
        end
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
              is_expected.not_to compile
            else
              is_expected.to contain_class('letsencrypt::plugin::dns_cloudflare').with_package_name(package_name)
              is_expected.to contain_package(package_name).with_ensure('installed')
            end
          end
        end

        describe 'with manage_package => false' do
          let(:params) { super().merge(manage_package: false, package_name: 'dns-cloudflare-package') }

          it { is_expected.not_to contain_package('dns-cloudflare-package') }
        end
      end
    end
  end
end
