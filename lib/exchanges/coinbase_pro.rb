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
      resp = @client.buy(
        amount,
        type: 'market',
        product_id: get_pair(pair)
      )

      order = @client.order(resp['id'])

      translate_order_to_result(order)

        raise resp['error'].join(',')
      elsif !resp['result']
        raise resp.inspect
      else
        res.message = resp['result']['descr']
        res.order_id = resp['result']['txid'].join
        res.status = TradeResult::STATUS::Success

        begin
          orders = @client.closed_orders
          order = orders['result']['closed'][res.order_id]

          raise 'Order not found' if !order

          res.price = order['price'].to_f
        rescue => e
          res.status = TradeResult::STATUS::Failed
          res.message = "Unable to verify order status: #{e.message}"
        end
      end

      res
    rescue => e
      res.message = e.message
      res.status = TradeResult::STATUS::Failed
      res
    end

    private

    def translate_order_to_result(order)
      res = TradeResult.new

      res.order_id = order['id']
      res.message = order['done_reason']
      res.price = order['executed_value'].to_f / order['size'].to_f

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
