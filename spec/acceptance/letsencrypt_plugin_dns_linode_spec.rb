# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::dns_linode' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include letsencrypt
      class { 'letsencrypt::plugin::dns_linode':
        api_key => 'dummy-linode-api-key',
      }
      PUPPET
    end
  end

  describe file('/etc/letsencrypt/dns-linode.ini') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 400 }
  end
end
