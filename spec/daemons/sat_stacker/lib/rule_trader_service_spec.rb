require 'rails_helper'
require "#{Rails.root}/daemons/sat_stacker/lib/rule_trader_service"

describe "RuleTraderService" do
  let(:rules) { 10.times.map {build(:rule)} }
  let(:bpc) { Hash.new { |hash, key| hash[key] = build(:bitcoin_price_change) } }
  subject {RuleTraderService.new(rules, bpc)}

  describe '.trade!' do
    it 'runs paid plans first' do
      paid_indexes = [2, 5, 7, 9]
      unpaid_indexes = (0..9).to_a - paid_indexes

      paid_indexes.each {|i| allow(rules[i].user).to receive(:has_paid_plan?).and_return(true)}

      paid_indexes.each {|i| expect(subject).to receive(:trade_rule).with(rules[i]).ordered }
      unpaid_indexes.each {|i| expect(subject).to receive(:trade_rule).with(rules[i]).ordered }

      subject.trade!
    end
  end
end
