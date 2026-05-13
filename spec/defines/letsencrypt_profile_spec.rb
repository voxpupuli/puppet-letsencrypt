# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::profile' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:title) { 'staging' }
      let(:letsencrypt_config_dir) do
        (facts['os']['family'] == 'FreeBSD') ? '/usr/local/etc/letsencrypt' : '/etc/letsencrypt'
      end
      let(:pre_condition) do
        <<-PUPPET
        class { 'letsencrypt':
          email         => 'spec@example.com',
        }
        PUPPET
      end

      context 'with valid config' do
        let(:params) do
          {
            config: {
              'email' => 'foo@example.com',
              'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting("#{letsencrypt_config_dir}/staging.ini email foo@example.com") }
        it { is_expected.to contain_ini_setting("#{letsencrypt_config_dir}/staging.ini server https://acme-staging-v02.api.letsencrypt.org/directory") }
      end

      context 'with custom config_file' do
        let(:params) do
          {
            config_file: '/tmp/staging.ini',
            config: {
              'email' => 'foo@example.com',
              'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting('/tmp/staging.ini email foo@example.com') }
        it { is_expected.to contain_ini_setting('/tmp/staging.ini server https://acme-staging-v02.api.letsencrypt.org/directory') }
      end

      context 'without email and unsafe_registration disabled' do
        let(:params) do
          {
            config: {
              'server' => 'https://acme-v02.api.letsencrypt.org/directory',
            },
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{Profile staging: Please specify an email address to register with Let's Encrypt}) }
      end

      context 'without email and with unsafe registration' do
        let(:params) do
          {
            config: {
              'server' => 'https://acme-v02.api.letsencrypt.org/directory',
              'register-unsafely-without-email' => true,
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting("#{letsencrypt_config_dir}/staging.ini register-unsafely-without-email true") }
      end
    end
  end
end
