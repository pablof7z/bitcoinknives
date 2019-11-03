require 'rails_helper'

describe "RuleConfigService" do
  describe ".exchanges" do
    it 'provides exchanges' do
      expect(RuleConfigService.exchanges).to include('kraken')
    end
  end

  describe '.periods' do
    it 'loads periods from yaml file as human-ready strings' do
      expect(RuleConfigService.periods).to include('24 hours')
    end
  end

  describe '.formulas' do
    it 'returns human format' do
      expect(RuleConfigService.formulas).to include('the same percentage x 100,000 sats')
    end
  end

  describe ".formulas_human_to_machine" do
    it "translates 'the same percentage x 100,000 sats' to 'x*100000'" do
      expect(RuleConfigService.formulas_human_to_machine('the same percentage x 100,000 sats')).to eq('x*1e5')
    end
  end

  describe '.period_in_seconds' do
    it 'returns the configured period in seconds' do
      expect(RuleConfigService.period_in_seconds('24 hours')).to eq(24.hours)
      expect(RuleConfigService.period_in_seconds('1 month')).to eq(1.month)
      expect(
        RuleConfigService.period_in_seconds('1 month') >
        RuleConfigService.period_in_seconds('24 hours')
      ).to be true
    end
  end

  describe '.trade_limit_for' do
    it 'returns the trade limit for the exchange in sats' do
      expect(RuleConfigService.trade_limit_for('kraken', type: 'min')).to eq(1e5)
    end
  end
end
