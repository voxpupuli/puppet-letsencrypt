require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::nginx' do
  supported = case fact('os.family')
              when 'Debian'
                # Debian 9 has it in backports, Ubuntu started shipping in Bionic
                fact('os.release.major') != '9' && fact('os.release.major') != '16.04'
              when 'RedHat'
                true
              else
                false
              end

  context 'with defaults values' do
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

    if supported
      it 'installs letsencrypt and nginx plugin without error' do
        apply_manifest(pp, catch_failures: true)
      end
      it 'installs letsencrypt and nginx idempotently' do
        apply_manifest(pp, catch_changes: true)
      end

    else
      it 'fails to install' do
        apply_manifest(pp, expect_failures: true)
      end
    end
  end
end
