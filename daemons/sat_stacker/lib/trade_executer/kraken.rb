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
      resp = client.add_order(
        pair: get_pair,
        type: 'buy',
        ordertype: 'market',
        volume: trade.amount
      )

      if resp['error'].any?
        raise resp['error'].join(',')
      elsif !resp['result']
        raise resp.inspect
      else
        @trade.update(
          tx_info: resp['result']['descr'],
          tx_id: resp['result']['txid'].join,
          tx_status: 'success',
        )

        begin
          orders = client.closed_orders
          order = orders['result']['closed'][@trade.tx_id]

          raise 'Order not found' if !order

          @trade.update(price: order['price'])
        rescue => e
          @trade.update(
            tx_status: 'failed',
            tx_info: "#{@trade.tx_info}\nUnable to verify order status: #{e.message}"
          )
        end
      end
    end

    private

    def get_pair
      "XBT#{trade.rule_base_currency}"
    end
  end
end
