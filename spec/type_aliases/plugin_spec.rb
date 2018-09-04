require 'spec_helper'

describe 'Letsencrypt::Plugin' do
  it { is_expected.to allow_values('apache', 'standalone', 'webroot', 'nginx', 'dns-route53', 'dns-google') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('foo') }
  it { is_expected.not_to allow_value('custom') }
end
