# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::nginx' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include letsencrypt
      include letsencrypt::plugin::nginx
      PUPPET
    end
  end
end
