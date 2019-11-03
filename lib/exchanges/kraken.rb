require 'kraken_ruby_client'
require 'exchanges/base'

module Exchanges
  class Kraken < Exchanges::Base
    attr_reader :client

    def initialize(api_key: nil, api_secret: nil)
      super
      @client = ::Kraken::Client.new(
        api_key: @api_key,
        api_secret: @api_secret,
      )
    end

    def valid_api_key?
      resp = @client.closed_orders

      return resp['error'].empty?
    end

    def get_pair(asset1: 'BTC', asset2:)
      asset1 = 'XBT' if asset1 == 'BTC'

      "#{asset1}#{asset2}"
    end

    def create_buy_market_order(pair:, amount:)
      resp = @client.add_order(
        pair: pair,
        type: 'buy',
        ordertype: 'market',
        volume: amount,
      )

      ret_val = {}

      if resp['error'].any?
        raise resp['error'].join(',')
      elsif !resp['result']
        raise resp.inspect
      else
        ret_val['tx_info'] = resp['result']['descr']
        ret_val['tx_id'] = resp['result']['txid'].join
        ret_val['tx_status'] = 'success'

        begin
          orders = @client.closed_orders
          order = orders['result']['closed'][ret_val['tx_id']]

          raise 'Order not found' if !order

          ret_val['price'] = order['price']
        rescue => e
          ret_val['tx_status'] = 'failed'
          ret_val['tx_info'] = "Unable to verify order status: #{e.message}"
        end
      end

      ret_val
    end
  end
end
