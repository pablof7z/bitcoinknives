module Exchanges
  class Base
    attr_reader :api

    def initialize(api={})
      @api = api
    end

    # Call a private method at the exchange to validate that the API key info is working
    def valid_api_key?
      raise NotImplementedError
    end

    # Map assets to exchange-specific asset pair
    def get_pair(asset1: 'BTC', asset2:)
      raise NotImplementedError
    end

    def create_buy_market_order(pair:, amount:)
      raise NotImplementedError
    end
  end
end
