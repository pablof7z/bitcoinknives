require 'rails_helper'

describe "Rule" do
  let (:rule) { build(:rule) }
  let (:trade_outside_period) { create(:trade_outside_period) }
  let (:trade_within_period) { create(:trade_within_period) }

  describe ".tradable?" do
    it "trades when it hasn't traded before" do
      expect(rule.tradable?).to be true
    end

    it "trades when it has traded outside the scope of the period" do
      expect(trade_outside_period.rule.tradable?).to be true
    end

    it "doesn't trade when it has traded within the current period" do
      expect(trade_within_period.rule.tradable?).to be false
    end
  end
end
