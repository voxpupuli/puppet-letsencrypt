# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::dns_cloudflare' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'letsencrypt' :
        email  => 'letsregister@example.com',
        config => {
          'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
        },
      }
      class { 'letsencrypt::plugin::dns_cloudflare':
        api_token => 'dummy-cloudflare-api-token',
      }
      PUPPET
    end
  end

  describe file('/etc/letsencrypt/dns-cloudflare.ini') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 400 }
  end
end
