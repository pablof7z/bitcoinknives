require 'rails_helper'

describe "TradeAmountCalculatorService" do
  let(:trade) { build(:trade) }
  let(:bpc) { create(:bitcoin_price_change) }

  describe "calculate" do
    it 'converts relative formulas' do
      trade.rule.formula = 'the same percentage x 100,000 sats'
      expect(bpc.change_percentage).to eq(-50)
      expect(TradeAmountCalculatorService.calculate(trade.rule, bpc.change_percentage)).to eq(0.05)
    end

    it 'handles absolute formulas' do
      trade.rule.formula = '100k sats (0.001 btc)'
      expect(TradeAmountCalculatorService.calculate(trade.rule, bpc.change_percentage)).to eq(0.001)
    end

    it 'takes into account rule trade limit' do
      trade.rule.max_sats_per_trade = '100k'
      trade.rule.formula = '1 btc'
      expect(TradeAmountCalculatorService.calculate(trade.rule, bpc.change_percentage)).to eq(0.001)
    end

    it 'takes into account rule period limit when it has already created trades' do
      allow(RuleExchangeValidator).to receive(:valid?) { true }
      trade.rule.max_sats_per_period = '1 btc'
      trade.rule.max_sats_per_trade = '1 btc'
      trade.rule.save!
      period  = RuleConfigService.period_in_seconds(trade.rule.max_sats_per_period_length)

      3.times do
        trade.rule.trades.create(
          amount: trade.rule.max_sats_per_period / 1e8 / 4,
          created_at: period.ago + 100,
          tx_status: TradeResult::STATUS::Success,
        )
      end

      trade.rule.formula = '1 btc'
      expect(TradeAmountCalculatorService.calculate(trade.rule, bpc.change_percentage)).to eq(1 / 4.0)
    end
  end
end
