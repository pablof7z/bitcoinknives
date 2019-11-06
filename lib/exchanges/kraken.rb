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

    def get_pair(assets)
      assets.map! {|a| translate_asset(a) }

      assets.join
    end

    def create_buy_market_order(pair:, amount:)
      res = TradeResult.new

      resp = @client.add_order(
        pair: get_pair(pair),
        type: 'buy',
        ordertype: 'market',
        volume: amount,
      )

      if !validate_kraken_response(resp)
        Raven.capture_message("Kraken replied with an unknown format.", extra: {response: resp.inspect})
        raise "Kraken replied with an unknown format: #{resp.inspect}"
      end

      if resp['error'].any?
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

    def validate_kraken_response(response)
      response['error'].is_a?(Array) ||
      (
        response['result'].is_a?(Hash) &&
        response['result']['descr'] &&
        response['result']['txid'].is_a?(Array)
      )

    end

    def translate_asset(asset)
      case asset
      when 'BTC' then 'XBT'
      else
        asset
      end
    end
  end

end
