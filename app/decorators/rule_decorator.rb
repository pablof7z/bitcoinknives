class RuleDecorator < Draper::Decorator
  delegate_all

  def card_class
    if !object.running?
    end
  end

  def price_change_class
    if price_change.to_f > 0
      'price-up'
    elsif price_change.to_f < 0
      'price-down'
    end
  end

  def price_change
    bpc = BitcoinPriceChange.where(period: change_period).first
    bpc.change_percentage.round(3) if bpc && bpc.change_percentage
  end

  def last_trade_time
    object.trades.order(created_at: :desc).first.created_at
  end

  def next_trade_time
    trade_execution_time_limit = RuleConfigService.period_in_seconds(object.change_period)
    ltt = last_trade_time
    ltt + trade_execution_time_limit
  end
end
