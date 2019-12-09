require 'coinbase/exchange'
require 'exchanges/base'

module Exchanges
  class CoinbasePro < Exchanges::Base
    attr_reader :client

    def initialize(api={})
      super
      @client = Coinbase::Exchange::Client.new(
        @api.exchange_api_key,
        @api.exchange_api_secret,
        @api.exchange_api_passphrase,
      )
    end

    def valid_api_key?
      resp = @client.accounts
      true
    rescue => e
      return false
    end

    def get_pair(assets)
      assets.map! {|a| translate_asset(a) }

      assets.join('-')
    end

    def create_buy_market_order(pair:, amount:)
      order = @client.bid_market(
        amount,
        product_id: pair,
      )

      res.order_id = order['id']

      # Yeah... refactor this to make it async
      100.times do
        order_status = @client.order(order['id'])
        if order_status['status'] == 'done'
          return translate_order_to_result(order_status)
        end
      end
    rescue => e
      tr = TradeResult.new
      tr.message = e.message
      tr.status = TradeResult::STATUS::Failed
      tr
    end

    private

    def translate_order_to_result(order)
      res = TradeResult.new

      res.order_id = order['id']
      res.message = order.to_s

      begin
        res.price = order_status['executed_value'].to_f / order_status['filled_size'].to_f
      rescue => e
        res.price = 0
        Raven.capture_message("Error calculating cbp price: #{order_status.to_s}: #{e.message}", extra: {order_status: order_status})
      end

      res.status = case order['status']
      when 'done' then TradeResult::STATUS::Success
      else
        Raven.capture_message("Unhandled cbpro status: #{order['status']}", extra: {order: order})
        TradeResult::STATUS::Failed
      end

      res
    end

    def translate_asset(asset)
      asset
    end
  end
end
