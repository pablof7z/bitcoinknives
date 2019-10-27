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
      expect(RuleConfigService.formulas).to include('the same percentage * 10000 sats')
    end
  end

  describe ".formulas_human_to_machine" do
    it "translates 'the same percentage * 10000 sats' to 'x*10000'" do
      expect(RuleConfigService.formulas_human_to_machine('the same percentage * 10000 sats')).to eq('x*10000')
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
end
