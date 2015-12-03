describe 'letsencrypt::certonly' do
  let(:facts) {{ osfamily: 'Debian' }}
  let(:pre_condition) { 'include letsencrypt' }

  context 'with a single domain' do
    let(:title) { 'foo.example.com' }
    it { is_expected.to contain_exec('letsencrypt certonly foo.example.com') }
    it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_creates '/etc/letsencrypt/live/foo.example.com/cert.pem' }
    it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly --standalone -d foo.example.com' }
  end

  context 'with multiple domains' do
    let(:title) { 'foo' }
    let(:params) {{ domains: ['foo.example.com', 'bar.example.com']}}
    it { is_expected.to contain_exec('letsencrypt certonly foo').with_command '/opt/letsencrypt/letsencrypt-auto certonly --standalone -d foo.example.com -d bar.example.com' }
  end

  context 'with custom path' do
    let(:title) { 'foo.example.com' }
    let(:params) {{ letsencrypt_path: '/usr/lib/letsencrypt' }}
    it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/usr/lib/letsencrypt/letsencrypt-auto certonly --standalone -d foo.example.com' }
  end

  context 'with custom plugin' do
    let(:title) { 'foo.example.com' }
    let(:params) {{ plugin: 'apache' }}
    it { is_expected.to contain_exec('letsencrypt certonly foo.example.com').with_command '/opt/letsencrypt/letsencrypt-auto certonly --apache -d foo.example.com' }
  end

  context 'with invalid plugin' do
    let(:title) { 'foo.example.com' }
    let(:params) {{ plugin: 'bad' }}
    it { is_expected.to raise_error Puppet::Error }
  end
end
