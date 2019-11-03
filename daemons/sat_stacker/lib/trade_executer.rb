require "trade_executer/kraken"

class TradeExecuter
  attr_reader :trade

  def initialize(trade)
    @trade = trade
  end

  def execute!
    klass = case trade.rule_exchange_name
    when 'kraken' then Exchange::Kraken
    else
      raise NotImplemented, "Exchange #{trade.rule_exchange_name} not implemented yet."
    end

    raise "Would have traded #{trade.amount}" if trade.amount > 0.01

    te = klass.new(trade)
    te.create_buy_market_order(pair: , amount: trade.amount)
  rescue => e
    @trade.update(
      tx_info: e.message,
      tx_status: 'failed',
    )
  ensure
    @trade.update(executed_at: Time.now)

    TradesChannel.broadcast_to(@trade.user_id, rule_id: @trade.rule_slug, trade_id: @trade.id)
  end
end
