require 'spec_helper'

describe 'Letsencrypt::Cron::Monthday' do
  describe 'valid handling' do
    it { is_expected.to allow_values(1, 31, '1', '31', [], [1, '31']) }
  end

  describe 'invalid handling' do
    it { is_expected.not_to allow_values(0, 32, '', '0', '32', [''], [0, '32']) }
  end
end
