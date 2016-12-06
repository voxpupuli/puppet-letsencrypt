describe 'letsencrypt::certonly' do
  { 'Debian' => '9.0', 'Ubuntu' => '16.04', 'RedHat' => '7.2' }.each do |osfamily, osversion|
    context "on #{osfamily} based operating systems" do
      let(:facts) { { osfamily: osfamily, operatingsystem: osfamily, operatingsystemrelease: osversion, operatingsystemmajrelease: osversion.split('.').first, path: '/usr/bin' } }
      let(:pre_condition) { "class { letsencrypt: email => 'foo@example.com', package_command => 'letsencrypt' }" }

      context 'with a single domain' do
        let(:title) { 'foo.example.com' }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com') }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_creates '/etc/letsencrypt/live/foo.example.com/cert.pem' }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command 'letsencrypt --text --agree-tos certonly -a standalone -d foo.example.com' }
      end

      context 'with multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com'] } }
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command 'letsencrypt --text --agree-tos certonly -a standalone -d foo.example.com -d bar.example.com' }
      end

      context 'with custom command' do
        let(:title) { 'foo.example.com' }
        let(:params) { { letsencrypt_command: '/usr/lib/letsencrypt/letsencrypt-auto' } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/usr/lib/letsencrypt/letsencrypt-auto --text --agree-tos certonly -a standalone -d foo.example.com' }
      end

      context 'with webroot plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          { plugin: 'webroot',
            webroot_paths: ['/var/www/foo'] }
        end
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command 'letsencrypt --text --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com' }
      end

      context 'with webroot plugin and multiple domains' do
        let(:title) { 'foo' }
        let(:params) do
          { domains: ['foo.example.com', 'bar.example.com'],
            plugin: 'webroot',
            webroot_paths: ['/var/www/foo', '/var/www/bar'] }
        end
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command 'letsencrypt --text --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com --webroot-path /var/www/bar -d bar.example.com' }
      end

      context 'with webroot plugin, one webroot, and multiple domains' do
        let(:title) { 'foo' }
        let(:params) do
          { domains: ['foo.example.com', 'bar.example.com'],
            plugin: 'webroot',
            webroot_paths: ['/var/www/foo'] }
        end
        it { is_expected.to contain_exec('letsencrypt certonly foo').with_command 'letsencrypt --text --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com -d bar.example.com' }
      end

      context 'with webroot plugin and no webroot_paths' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'webroot' } }
        it { is_expected.to raise_error Puppet::Error, %r{'webroot_paths' parameter must be specified} }
      end

      context 'with custom plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache' } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command 'letsencrypt --text --agree-tos certonly -a apache -d foo.example.com' }
      end

      context 'with custom plugin and manage cron' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          { plugin: 'apache',
            manage_cron: true }
        end
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command 'letsencrypt --text --agree-tos certonly -a apache --keep-until-expiring -d foo.example.com' }
      end

      context 'with custom plugin and manage cron and cron_success_command' do
        let(:title) { 'foo.example.com' }
        let(:params) do
          { plugin: 'apache',
            manage_cron: true,
            cron_before_command: 'echo before',
            cron_success_command: 'echo success' }
        end
        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_command '(echo before) && letsencrypt --text --agree-tos certonly -a apache --keep-until-expiring -d foo.example.com && (echo success)' }
      end

      context 'with invalid plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'bad' } }
        it { is_expected.to raise_error Puppet::Error }
      end

      context 'when specifying additional arguments' do
        let(:title) { 'foo.example.com' }
        let(:params) { { additional_args: ['--foo bar', '--baz quux'] } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command 'letsencrypt --text --agree-tos certonly -a standalone -d foo.example.com --foo bar --baz quux' }
      end

      describe 'when specifying custom environment variables' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: ['FOO=bar', 'FIZZ=buzz'] } }
        it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_environment(['VENV_PATH=/opt/letsencrypt/.venv', 'FOO=bar', 'FIZZ=buzz']) }
      end

      context 'with custom environment variables and manage cron' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: ['FOO=bar', 'FIZZ=buzz'], manage_cron: true } }

        it { is_expected.to contain_cron('letsencrypt renew cron foo.example.com').with_environment(['VENV_PATH=/opt/letsencrypt/.venv', 'FOO=bar', 'FIZZ=buzz']) }
      end
    end
  end
end
