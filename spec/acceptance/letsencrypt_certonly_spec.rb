require 'spec_helper_acceptance'

describe 'letsencrypt::certonly' do
  context 'with ' do
    pp = %(
      class { 'letsencrypt' :
        email  => 'letsregister@example.com',
        config => {
          'server' => 'https://acme-staging.api.letsencrypt.org/directory',
        },
      }

      letsencrypt::certonly { 'foo':
        domains              => ['foo.example.com', 'bar.example.com'],
        ensure_cron          => 'present',
        cron_hour            => [0,12],
        cron_minute          => '30',
        cron_before_command  => 'service apache stop',
        cron_success_command => 'service apache start',
        suppress_cron_output => true,
      }
    )

    it 'configures certificate without error' do
      apply_manifest(pp, catch_failures: true)
    end
    it 'configures certificate idempotently' do
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/opt/puppetlabs/puppet/cache/letsencrypt/renew-foo.sh') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 755 }
    end
    describe cron do
      it { is_expected.to have_entry '30 0,12 * * * "/opt/puppetlabs/puppet/cache/letsencrypt/renew-foo.sh"' }
    end
  end
end
