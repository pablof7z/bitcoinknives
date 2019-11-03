require 'rails_helper'

describe "Rule" do
  let (:rule) { build(:rule) }
  let (:trade_outside_period) { create(:trade_outside_period) }
  let (:trade_within_period) { create(:trade_within_period) }

  describe ".tradable?" do
    before do
      allow(RuleExchangeValidator).to receive(:valid?).and_return(true)
    end

    it "trades when it hasn't traded before" do
      expect(rule.tradable?).to be true
    end

    it "trades when it has traded outside the scope of the period" do
      expect(trade_outside_period.rule.tradable?).to be true
    end

    it "doesn't trade when it has traded within the current period" do
      expect(trade_within_period.rule.tradable?).to be false
    end

    context 'when it has reached the limit of trades per period' do
      it "doesn't trade" do
        expect(trade_within_period.rule.tradable?).to be false
      end
    end
  end

  describe '.save' do
    context 'when it has api key information' do
      it 'validates that the api key is working' do
        rule.exchange_name = 'kraken'
        rule.exchange_api_key = 'something'
        rule.exchange_api_secret = 'something'

        expect(RuleExchangeValidator).to receive(:valid?).and_return(false)

        expect{
          rule.save!
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when it doesn't have api key information" do
      it "doesn't validate the api key if it's empty" do
        rule.exchange_api_key = nil
        rule.exchange_api_secret = nil

        expect{
          rule.save!
        }.to_not raise_error
      end
    end
  end
end
