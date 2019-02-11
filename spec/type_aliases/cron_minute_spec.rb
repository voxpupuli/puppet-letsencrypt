require 'spec_helper'

describe 'Letsencrypt::Cron::Minute' do
  describe 'valid handling' do
    it { is_expected.to allow_values(0, 59, '0', '59', [], [0, '59']) }
  end

  describe 'invalid handling' do
    it { is_expected.not_to allow_values(-1, 60, '', '-1', '60', [''], [-1, '60']) }
  end
end
