# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt' do
  context 'with defaults values' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) { 'include letsencrypt' }
    end

    describe file('/etc/letsencrypt/cli.ini') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match %r{server = https://acme-staging-v02.api.letsencrypt.org/directory} }
      its(:content) { is_expected.to match %r{email = letsregister@example.com} }
    end
  end
end
