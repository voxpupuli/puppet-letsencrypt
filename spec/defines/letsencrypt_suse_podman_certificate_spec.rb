# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::suse::podman::certificate' do
  let(:facts) do
    {
      os: {
        name: 'SLES',
        release: { full: '15.5' },
      },
    }
  end

  let(:pre_condition) do
    "class { 'letsencrypt::suse::podman': email => 'foo@example.com' }"
  end

  let(:title) { 'www.example.com' }

  it { is_expected.to compile.with_all_deps }

  it do
    is_expected.to contain_exec('letsencrypt-suse-podman-certificate-www.example.com').with(
      command: "/usr/local/lib/letsencrypt/certbot-podman.sh certonly --dns-azure --cert-name 'www.example.com' -d 'www.example.com'",
      unless: "test -f '/etc/letsencrypt/live/www.example.com/cert.pem'",
    )
  end

  context 'with multiple domains and additional arguments' do
    let(:params) do
      {
        domains: ['www.example.com', 'api.example.com'],
        additional_args: ['--staging'],
      }
    end

    it do
      is_expected.to contain_exec('letsencrypt-suse-podman-certificate-www.example.com').with_command(
        "/usr/local/lib/letsencrypt/certbot-podman.sh certonly --dns-azure --cert-name 'www.example.com' -d 'www.example.com' -d 'api.example.com' --staging",
      )
    end
  end

  context 'with ensure => absent' do
    let(:params) { { ensure: 'absent' } }

    it do
      is_expected.to contain_exec('letsencrypt-suse-podman-certificate-www.example.com').with(
        command: "/usr/local/lib/letsencrypt/certbot-podman.sh delete --cert-name 'www.example.com' --non-interactive",
        onlyif: "test -f '/etc/letsencrypt/live/www.example.com/cert.pem'",
      )
    end
  end
end
