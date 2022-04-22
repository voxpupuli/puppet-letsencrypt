# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::dns_rfc2136' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include letsencrypt
      class { 'letsencrypt::plugin::dns_rfc2136':
        server     => '192.0.2.1',
        key_name   => 'certbot',
        key_secret => 'secret',
      }
      PUPPET
    end
  end

  describe file('/etc/letsencrypt/dns-rfc2136.ini') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 400 }
  end
end
