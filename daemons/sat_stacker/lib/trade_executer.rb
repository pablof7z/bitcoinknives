require "exchanges"

class TradeExecuter
  attr_reader :trade

  def initialize(trade)
    @trade = trade
  end

  def execute!
    klass = case trade.exchange_name
    when 'kraken' then Exchanges::Kraken
    when 'coinbase pro' then Exchanges::CoinbasePro
    else
      raise NotImplemented, "Exchange #{trade.exchange_name} not implemented yet."
    end

    raise "Would have traded #{trade.amount}" if trade.amount > 0.01

    te = klass.new(
      api: {
        key: trade.exchange_api_key,
        secret: trade.exchange_api_secret,
        passphrase: trade.exchange_api_passphrase,
      }
    )

    # Bitcoin maximalism ☣️
    resp = te.create_buy_market_order(pair: ['BTC', trade.base_currency], amount: trade.amount)

    @trade.update(
      tx_info: resp.message,
      tx_id: resp.order_id,
      tx_status: resp.status,
      price: resp.price,
    )

    TradesChannel.broadcast_to(@trade.user_id, rule_id: @trade.rule_slug, trade_id: @trade.id)
  rescue => e
    @trade.update(
      tx_info: e.message,
      tx_status: TradeResult::STATUS::Failed,
    )
  ensure
    @trade.update(executed_at: Time.now)

  end
end
