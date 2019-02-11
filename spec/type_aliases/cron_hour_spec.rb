require 'spec_helper'

describe 'Letsencrypt::Cron::Hour' do
  describe 'valid handling' do
    it { is_expected.to allow_values(0, 23, '0', '23', [], [0, '23']) }
  end

  describe 'invalid handling' do
    it { is_expected.not_to allow_values(-1, 24, '', '-1', '24', [''], [-1, '24']) }
  end
end
