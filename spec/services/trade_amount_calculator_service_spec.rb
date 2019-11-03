require 'rails_helper'

describe "TradeAmountCalculatorService" do
  let(:trade) { build(:trade) }
  let(:bpc) { create(:bitcoin_price_change) }

  describe "calculate" do
    it 'converts relative formulas' do
      trade.rule.formula = 'the same percentage x 100,000 sats'
      expect(bpc.change_percentage).to eq(-50)
      expect(TradeAmountCalculatorService.calculate(trade.rule_formula, bpc.change_percentage)).to eq(0.05)
    end

    it 'handles absolute formulas' do
      trade.rule.formula = '100k sats (0.001 btc)'
      expect(TradeAmountCalculatorService.calculate(trade.rule_formula, bpc.change_percentage)).to eq(0.001)
    end
  end
end
