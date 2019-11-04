require "exchanges/kraken"

class TradeExecuter
  attr_reader :trade

  def initialize(trade)
    @trade = trade
  end

  def execute!
    klass = case trade.exchange_name
    when 'kraken' then Exchanges::Kraken
    else
      raise NotImplemented, "Exchange #{trade.exchange_name} not implemented yet."
    end

    raise "Would have traded #{trade.amount}" if trade.amount > 0.01

    te = klass.new(
      api_key: trade.exchange_api_key,
      api_secret: trade.exchange_api_secret,
    )
    resp = te.create_buy_market_order(pair: ['BTC', trade.base_currency], amount: trade.amount)

    @trade.update(
      tx_info: resp.message,
      tx_id: resp.order_id,
      tx_status: resp.status,
      price: resp.price,
    )
  rescue => e
    @trade.update(
      tx_info: e.message,
      tx_status: TradeResult::STATUS::Failed,
    )
  ensure
    @trade.update(executed_at: Time.now)

    TradesChannel.broadcast_to(@trade.user_id, rule_id: @trade.rule_slug, trade_id: @trade.id)
  end
end
