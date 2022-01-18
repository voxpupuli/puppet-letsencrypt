# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::nginx' do
  context 'with default values' do
    pp = <<-PUPPET
      class { 'letsencrypt' :
        email  => 'letsregister@example.com',
        config => {
          'server' => 'https://acme-staging.api.letsencrypt.org/directory',
        },
      }
      class { 'letsencrypt::plugin::nginx':
      }
    PUPPET

    it 'installs letsencrypt and nginx plugin without error' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'installs letsencrypt and nginx idempotently' do
      apply_manifest(pp, catch_changes: true)
    end
  end
end
