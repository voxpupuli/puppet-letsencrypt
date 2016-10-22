describe 'certbot::certonly' do
  {'Debian' => '9.0', 'Ubuntu' => '16.04', 'RedHat' => '7.2'}.each do |osfamily, osversion|
    context "on #{osfamily} based operating systems" do
      let(:facts) { { osfamily: osfamily, operatingsystem: osfamily, operatingsystemrelease: osversion, operatingsystemmajrelease: osversion.split('.').first, path: '/usr/bin' } }
      let(:pre_condition) { "class { certbot: email => 'foo@example.com', package_command => 'certbot' }" }

      context 'with a single domain' do
        let(:title) { 'foo.example.com' }
        it { is_expected.to contain_exec('certbot certonly foo.example.com') }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_creates '/etc/certbot/live/foo.example.com/cert.pem' }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_command 'certbot --agree-tos certonly -a standalone -d foo.example.com' }
      end

      context 'with multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com'] } }
        it { is_expected.to contain_exec('certbot certonly foo').with_command 'certbot --agree-tos certonly -a standalone -d foo.example.com -d bar.example.com' }
      end

      context 'with custom command' do
        let(:title) { 'foo.example.com' }
        let(:params) { { certbot_command: '/usr/lib/certbot/certbot-auto' } }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_command '/usr/lib/certbot/certbot-auto --agree-tos certonly -a standalone -d foo.example.com' }
      end

      context 'with webroot plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'webroot',
                         webroot_paths: ['/var/www/foo'] } }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_command 'certbot --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com' }
      end

      context 'with webroot plugin and multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com'],
                         plugin: 'webroot',
                         webroot_paths: ['/var/www/foo', '/var/www/bar'] } }
        it { is_expected.to contain_exec('certbot certonly foo').with_command 'certbot --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com --webroot-path /var/www/bar -d bar.example.com' }
      end

      context 'with webroot plugin, one webroot, and multiple domains' do
        let(:title) { 'foo' }
        let(:params) { { domains: ['foo.example.com', 'bar.example.com'],
                         plugin: 'webroot',
                         webroot_paths: ['/var/www/foo'] } }
        it { is_expected.to contain_exec('certbot certonly foo').with_command 'certbot --agree-tos certonly -a webroot --webroot-path /var/www/foo -d foo.example.com -d bar.example.com' }
      end

      context 'with webroot plugin and no webroot_paths' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'webroot' } }
        it { is_expected.to raise_error Puppet::Error, /'webroot_paths' parameter must be specified/ }
      end

      context 'with custom plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache' } }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_command 'certbot --agree-tos certonly -a apache -d foo.example.com' }
      end

      context 'with custom plugin and manage cron' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache',
                         manage_cron: true } }
        it { is_expected.to contain_cron('certbot renew cron foo.example.com').with_command 'certbot --agree-tos certonly -a apache -t --keep-until-expiring -d foo.example.com' }
      end

      context 'with custom plugin and manage cron and cron_success_command' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'apache',
                         manage_cron: true,
                         cron_success_command: "echo success" } }
        it { is_expected.to contain_cron('certbot renew cron foo.example.com').with_command 'certbot --agree-tos certonly -a apache -t --keep-until-expiring -d foo.example.com && (echo success)' }
      end

      context 'with invalid plugin' do
        let(:title) { 'foo.example.com' }
        let(:params) { { plugin: 'bad' } }
        it { is_expected.to raise_error Puppet::Error }
      end

      context 'when specifying additional arguments' do
        let(:title) { 'foo.example.com' }
        let(:params) { { additional_args: ['--foo bar', '--baz quux'] } }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_command 'certbot --agree-tos certonly -a standalone -d foo.example.com --foo bar --baz quux' }
      end

      describe 'when specifying custom environment variables' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: [ 'FOO=bar', 'FIZZ=buzz' ] } }
        it { is_expected.to contain_exec('certbot certonly foo.example.com').with_environment([ "VENV_PATH=/opt/certbot/.venv", 'FOO=bar', 'FIZZ=buzz' ]) }
      end

      context 'with custom environment variables and manage cron' do
        let(:title) { 'foo.example.com' }
        let(:params) { { environment: [ 'FOO=bar', 'FIZZ=buzz' ], manage_cron: true } }

        it { is_expected.to contain_cron('certbot renew cron foo.example.com').with_environment([ "VENV_PATH=/opt/certbot/.venv", 'FOO=bar', 'FIZZ=buzz' ]) }
      end
    end
  end
end
