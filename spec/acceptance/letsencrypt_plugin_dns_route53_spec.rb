require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::dns_route53' do
  context 'with defaults values' do
    pp = <<-PUPPET
      class { 'letsencrypt' :
        email  => 'letsregister@example.com',
        config => {
          'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
        },
      }
      class { 'letsencrypt::plugin::dns_route53':
      }
    PUPPET

    it 'installs letsencrypt and dns route53 plugin without error' do
      apply_manifest(pp, catch_failures: true)
    end
    it 'installs letsencrypt and dns route53 idempotently' do
      apply_manifest(pp, catch_changes: true)
    end
  end
end
