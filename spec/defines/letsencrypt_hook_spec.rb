require 'spec_helper'

describe 'letsencrypt::hook' do
  on_supported_os.each do |os, facts|
    let(:title) { 'foo.example.com' }

    let(:pre_condition) { ["class { letsencrypt: email => 'foo@example.com', package_command => 'letsencrypt' }"] }
    let(:params) { default_params.merge(required_params).merge(additional_params) }
    let(:default_params) { {} }
    let(:required_params) { {} }
    let(:additional_params) { {} }

    let :facts do
      facts
    end

    context 'without required parameters' do
      it { is_expected.not_to compile }
    end

    context "on #{os} based operating systems" do
      context 'with pre hook' do
        let(:required_params) do
          { type: 'pre',
            hook_file: '/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-pre.sh',
            commands: ['FooBar'] }
        end

        it do
          is_expected.to contain_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-pre.sh').
            with(ensure: 'file',
                 owner: 'root',
                 group: 'root',
                 mode: '0755',
                 content: %r{^.*validate_env=0.*FooBar.*$}m).
            that_requires('File[letsencrypt-renewal-hooks-puppet]')
        end
      end

      context 'with post hook' do
        let(:required_params) do
          { type: 'post',
            hook_file: '/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-post.sh',
            commands: ['FooBar'] }
        end

        it do
          is_expected.to contain_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-post.sh').
            with_content(%r{^.*validate_env=0.*FooBar.*$}m)
        end
      end

      describe 'with deploy hook' do
        let(:required_params) do
          { type: 'deploy',
            hook_file: '/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-deploy.sh',
            commands: ['FooBar'] }
        end

        it do
          is_expected.to contain_file('/etc/letsencrypt/renewal-hooks-puppet/foo.example.com-deploy.sh').
            with_content(%r{^.*validate_env=1.*FooBar.*$}m)
        end
      end
    end
  end
end
