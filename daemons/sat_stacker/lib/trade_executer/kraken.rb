require 'kraken_ruby_client'

module TradeExecuterExchange
  class KrakenExchange
    attr_reader :trade, :client

    def initialize(trade)
      @trade = trade
      @client = Kraken::Client.new(
        api_key: trade.rule_exchange_api_key,
        api_secret: trade.rule_exchange_api_secret
      )
    end

    def exec
    end

    private

    def get_pair
      "XBT#{trade.rule_base_currency}"
    end
  end
end
