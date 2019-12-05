require 'rails_helper'
require 'rule_trader_policy'

describe 'RuleTraderPolicy' do
  subject { RuleTraderPolicy }
  let (:rule) { build(:rule) }
  let (:bpc) { build(:bitcoin_price_change) }

  describe 'sufficient_price_change?' do
    it 'returns true when price change limit is over bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -10

      expect(subject.sufficient_price_change?(rule, bpc)).to be true
    end

    it 'returns true when price change limit is the same as bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -5

      expect(subject.sufficient_price_change?(rule, bpc)).to be true
    end

    it 'returns false when price change limit is lower than bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -1

      expect(subject.sufficient_price_change?(rule, bpc)).to be false
    end
  end

  describe '.rule_traded_within_change_period?' do
    before do
      allow(RuleExchangeValidator).to receive(:valid?) { true }
    end

    it 'returns true when the rule was traded within the change period' do
      rule.save!
      period  = RuleConfigService.period_in_seconds(rule.change_period)
      rule.trades.create(
        amount: rule.max_sats_per_trade / 1e8,
        created_at: period.ago + 10,
        tx_status: TradeResult::STATUS::Success,
      )

      expect(subject.rule_traded_within_change_period?(rule)).to be true
    end

    it "returns false when the rule wasn't traded within the change period" do
      rule.save!
      period  = RuleConfigService.period_in_seconds(rule.change_period)
      rule.trades.create(
        amount: rule.max_sats_per_trade / 1e8,
        created_at: period.ago - 10,
        tx_status: TradeResult::STATUS::Success,
      )

      expect(subject.rule_traded_within_change_period?(rule)).to be false
    end
  end

  describe 'rule_within_trade_limits?' do
    before do
      allow(RuleExchangeValidator).to receive(:valid?) { true }

      rule.save!
      period  = RuleConfigService.period_in_seconds(rule.max_sats_per_period_length)

      number_of_trades.times do
        rule.trades.create(
          amount: rule.max_sats_per_period / 1e8 / 4,
          created_at: period.ago + 10,
          tx_status: TradeResult::STATUS::Success,
        )
      end
    end

    context 'rule was traded 3 times at 1/4 the permited amount per trade' do
      let (:number_of_trades) { 3 }

      it 'returns true when the rule was traded multiple times, and the sum of all successful trades is below the limit' do
        expect(subject.rule_within_trade_limits?(rule)).to be true
      end
    end

    context 'rule was traded 4 times at 1/4 the permited amount per trade' do
      let (:number_of_trades) { 4 }

      it 'returns false when the rule was traded multiple times, and the sum of all successful trades is higher than the limit' do
        expect(subject.rule_within_trade_limits?(rule)).to be false
      end
    end
  end
end
