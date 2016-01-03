describe 'letsencrypt::certonly' do
  ['Debian', 'RedHat'].each do |osfamily|
    context "on #{osfamily} based operating systems" do
      let(:facts) { { osfamily: osfamily } }
      let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com' }" }

      context 'with a single domain' do
        let(:title) { 'foo.example.com' }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_creates '/etc/letsencrypt/live/foo.example.com/cert.pem' }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly -a standalone -d foo.example.com' }
      end

      context 'with multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com'] } }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command '/opt/letsencrypt/letsencrypt-auto certonly -a standalone -d foo.example.com -d bar.example.com' }
      end

      context 'with custom path' do
        let(:title) { 'foo.example.com' }
        let(:params) { { letsencrypt_path: '/usr/lib/letsencrypt' } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/usr/lib/letsencrypt/letsencrypt-auto certonly -a standalone -d foo.example.com' }
      end

      context 'with custom plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache' } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly -a apache -d foo.example.com' }
      end

      context 'with custom plugin and manage cron' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache',
                         manage_cron: true } }
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly -a apache --keep-until-expiring -d foo.example.com' }
      end

      context 'with invalid plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'bad' } }
        it { is_expected.to raise_error Puppet::Error }
      end

      context 'when specifying additional arguments' do
        let(:title) { 'foo.example.com' }
        let(:params) { { additional_args: ['--foo bar', '--baz quux'] } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly -a standalone -d foo.example.com --foo bar --baz quux' }
      end
    end
  end
end
