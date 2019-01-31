require 'spec_helper'

describe 'letsencrypt::plugin::dns_rfc2136' do
  on_supported_os.each do |os, facts|
    let(:facts) do
      facts
    end

    let(:params) { default_params.merge(required_params).merge(additional_params) }
    let(:default_params) do
      { key_algorithm: 'HMAC-SHA512',
        port: 53,
        manage_package: true,
        config_dir: '/etc/letsencrypt',
        propagation_seconds: 10 }
    end
    let(:required_params) { {} }
    let(:additional_params) { {} }

    context 'without required parameters' do
      it { is_expected.not_to compile }
    end

    context "on #{os} based operating systems" do
      let(:required_params) do
        { server: '1.2.3.4',
          key_name: 'certbot',
          key_secret: 'secret' }
      end
      let(:pre_condition) do
        "class { letsencrypt:
          email           => 'foo@example.com',
          config_dir      => '/etc/letsencrypt',
          package_command => 'letsencrypt',
        }"
      end

      it { is_expected.to compile.with_all_deps }

      describe 'with manage_package => true' do
        let(:additional_params) { { manage_package: true } }

        it { is_expected.to contain_package('python2-certbot-dns-rfc2136').with_ensure('installed') }
      end

      describe 'with manage_package => false' do
        let(:additional_params) { { manage_package: false } }

        it { is_expected.not_to contain_package('python2-certbot-dns-rfc2136') }
      end

      it do
        is_expected.to contain_file('/etc/letsencrypt/dns-rfc2136.ini').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0400'
        ).with_content(%r{^.*dns_rfc2136_server.*$})
      end
    end
  end
end
