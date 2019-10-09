require 'spec_helper_acceptance'

describe 'letsencrypt::plugin::dns_rfc2136' do
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
          'server' => 'https://acme-staging-v02.api.letsencrypt.org/directory',
        },
      }
      class { 'letsencrypt::plugin::dns_rfc2136':
        server     => '192.0.2.1',
        key_name   => 'certbot',
        key_secret => 'secret',
      }
    PUPPET

    if supported
      it 'installs letsencrypt and dns rfc2136 plugin without error' do
        apply_manifest(pp, catch_failures: true)
      end
      it 'installs letsencrypt and dns rfc2136 idempotently' do
        apply_manifest(pp, catch_changes: true)
      end

      describe file('/etc/letsencrypt/dns-rfc2136.ini') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
        it { is_expected.to be_mode 400 }
      end
    else
      it 'fails to install' do
        apply_manifest(pp, expect_failures: true)
      end
    end
  end
end
