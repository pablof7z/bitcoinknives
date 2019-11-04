require 'rails_helper'
require 'exchanges/kraken'

describe "Exchanges::Kraken" do
  subject { Exchanges::Kraken.new(api_key: 'abc', api_secret: 'abc') }

  describe '.create_buy_market_order' do
    it 'sends buy order' do
      expect(subject.client).to receive(:add_order).with(
        ordertype: 'market',
        pair: 'XBTUSD',
        type: 'buy',
        volume: 0.0001,
      )

      subject.create_buy_market_order(pair: %w(BTC USD), amount: 0.0001)
    end
  end
end
