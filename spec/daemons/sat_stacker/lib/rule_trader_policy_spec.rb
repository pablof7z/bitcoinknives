require 'rails_helper'
require 'rule_trader_policy'

describe 'RuleTraderPolicy' do
  subject { RuleTraderPolicy }
  let (:rule) { build(:rule) }
  let (:bpc) { build(:bitcoin_price_change) }

  describe 'should_execute_trade?' do
    it 'returns true when price change limit is over bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -10

      expect(subject.should_execute_trade?(rule, bpc)).to be true
    end

    it 'returns true when price change limit is the same as bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -5

      expect(subject.should_execute_trade?(rule, bpc)).to be true
    end

    it 'returns false when price change limit is lower than bitcoin price change' do
      rule.change_percentage = 5.00
      rule.change_period = bpc.period
      bpc.change_percentage = -1

      expect(subject.should_execute_trade?(rule, bpc)).to be false
    end
  end
end
