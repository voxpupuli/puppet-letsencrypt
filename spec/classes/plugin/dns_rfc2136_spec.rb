# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::plugin::dns_rfc2136' do
  on_supported_os.each do |os, facts|
    context "on #{os} based operating systems" do
      let(:facts) { facts }
      let(:params) { {} }
      let(:pre_condition) do
        <<-PUPPET
        class { 'letsencrypt':
          email => 'foo@example.com',
        }
        PUPPET
      end
      let(:package_name) do
        case facts['os']['family']
        when 'FreeBSD'
          'py311-certbot-dns-rfc2136'
        when 'OpenBSD'
          ''
        else
          'python3-certbot-dns-rfc2136'
        end
      end

      context 'without required parameters' do
        it { is_expected.not_to compile }
      end

      context 'with required parameters' do
        let(:params) do
          super().merge(
            server: '192.0.2.1',
            key_name: 'certbot',
            key_secret: 'secret'
          )
        end

        # FreeBSD uses a different filesystem path
        let(:pathprefix) { facts['kernel'] == 'FreeBSD' ? '/usr/local' : '' }

        it do
          if package_name.empty?
            is_expected.not_to compile
          else
            is_expected.to compile.with_all_deps

            is_expected.to contain_file("#{pathprefix}/etc/letsencrypt/dns-rfc2136.ini").
              with_ensure('file').
              with_owner('root').
              with_group('0').
              with_mode('0400').
              with_content(%r{^.*dns_rfc2136_server.*$})
          end
        end

        describe 'with manage_package => true' do
          let(:params) { super().merge(manage_package: true) }

          it do
            if package_name.empty?
              is_expected.not_to compile
            else
              is_expected.to contain_class('letsencrypt::plugin::dns_rfc2136').with_package_name(package_name)
              is_expected.to contain_package(package_name).with_ensure('installed')
            end
          end
        end

        describe 'with manage_package => false' do
          let(:params) { super().merge(manage_package: false, package_name: 'dns-rfc2136-package') }

          it { is_expected.not_to contain_package('dns-rfc2136-package') }
        end
      end
    end
  end
end
