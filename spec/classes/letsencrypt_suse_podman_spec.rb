# frozen_string_literal: true

require 'spec_helper'

describe 'letsencrypt::suse::podman' do
  on_supported_os(facterversion: '3.11').each do |os, os_facts|
    # Only test on SLES
    next unless os_facts[:os]['name'] == 'SLES'

    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          email: 'foo@example.com',
        }
      end

      it { is_expected.to compile }

      it { is_expected.to contain_package('podman').with_ensure('installed') }
      it { is_expected.to contain_service('podman').with(ensure: 'running', enable: true) }

      it { is_expected.to contain_file('/etc/letsencrypt').with(ensure: 'directory', mode: '0755') }
      it { is_expected.to contain_file('/usr/local/lib/letsencrypt').with(ensure: 'directory') }

      it do
        is_expected.to contain_file('/usr/local/lib/letsencrypt/certbot-podman.sh').with(
          ensure: 'file',
          mode: '0755',
        )
      end

      it { is_expected.to contain_cron('letsencrypt-suse-podman-renew').with_ensure('present') }

      context 'with renew_cron_ensure => absent' do
        let(:params) do
          super().merge(renew_cron_ensure: 'absent')
        end

        it { is_expected.to contain_cron('letsencrypt-suse-podman-renew').with_ensure('absent') }
      end

      context 'with manage_podman => false' do
        let(:params) do
          super().merge(manage_podman: false)
        end

        it { is_expected.to compile }

        it { is_expected.not_to contain_package('podman') }
        it { is_expected.not_to contain_service('podman') }
      end

      context 'with manage_azure_config => true and azure_config_content provided' do
        let(:params) do
          super().merge(
            manage_azure_config: true,
            azure_config_content: "[azure]\nclient_id = test\nclient_secret = test\n",
          )
        end

        it do
          is_expected.to contain_file('/etc/letsencrypt/azure.ini').with(
            ensure: 'file',
            mode: '0600',
            content: "[azure]\nclient_id = test\nclient_secret = test\n",
          )
        end
      end

      context 'with custom container image and tag' do
        let(:params) do
          super().merge(
            container_image: 'my-registry/certbot',
            container_tag: 'v2.0.0',
          )
        end

        it { is_expected.to compile }

        # Verify the wrapper script contains the custom image
        it do
          is_expected.to contain_file('/usr/local/lib/letsencrypt/certbot-podman.sh').with(
            content: %r{my-registry/certbot:v2\.0\.0},
          )
        end
      end
    end
  end

  # Test OS validation: should fail on non-SLES
  context 'on Debian 11' do
    let(:facts) do
      {
        os: {
          name: 'Debian',
          release: { full: '11' },
        },
      }
    end
    let(:params) do
      {
        email: 'foo@example.com',
      }
    end

    it do
      is_expected.to compile.and_raise_error(
        %r{letsencrypt::suse::podman is only supported on SLES systems},
      )
    end
  end

  # Test SLES range validation
  context 'on SLES 15.3 (unsupported)' do
    let(:facts) do
      {
        os: {
          name: 'SLES',
          release: { full: '15.3' },
        },
      }
    end
    let(:params) do
      {
        email: 'foo@example.com',
      }
    end

    it do
      is_expected.to compile.and_raise_error(
        %r{letsencrypt::suse::podman currently supports SLES releases 15\.4 through 15\.7},
      )
    end
  end

  context 'with enforce_sles_range => false' do
    let(:facts) do
      {
        os: {
          name: 'SLES',
          release: { full: '15.3' },
        },
      }
    end
    let(:params) do
      {
        email: 'foo@example.com',
        enforce_sles_range: false,
      }
    end

    it { is_expected.to compile }
  end
end
