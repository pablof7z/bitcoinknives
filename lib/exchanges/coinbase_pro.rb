require 'coinbase/exchange'
require 'exchanges/base'

module Exchanges
  class CoinbasePro < Exchanges::Base
    attr_reader :client

    def initialize(api={})
      super
      @client = Coinbase::Exchange::Client.new(
        @api[:key],
        @api[:secret],
        @api[:passphrase],
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

      if !order || !order['id']
        raise "Coinbase replied with an unexpected message '#{order.inspect}'"
      end

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
        res.price = order['executed_value'].to_f / order['filled_size'].to_f
      rescue => e
        res.price = 0
        Raven.capture_message("Error calculating cbp price: #{order.to_s}: #{e.message}", extra: {order_status: order})
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
