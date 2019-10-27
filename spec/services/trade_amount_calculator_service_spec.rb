require 'rails_helper'

describe "TradeAmountCalculatorService" do
  let(:trade) { build(:trade) }
  let(:bpc) { create(:bitcoin_price_change) }

  describe "calculate" do
    it 'converts relative formulas' do
      trade.rule.formula = 'the same percentage * 10000 sats'
      expect(bpc.change_percentage).to eq(-50)
      expect(TradeAmountCalculatorService.calculate(trade, bpc)).to eq(0.005)
    end

    it 'handles absolute formulas' do
      trade.rule.formula = '100,000 sats'
      expect(TradeAmountCalculatorService.calculate(trade, bpc)).to eq(0.001)
    end
  end
end
