class RuleDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def card_class
    if !object.running?
    end
  end

  def max_sats_per_trade
    number_to_human(object.max_sats_per_trade).downcase
  end

  def max_sats_per_period
    number_to_human(object.max_sats_per_period).downcase
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

  def last_trade
    object.trades.successful.order(created_at: :desc).first
  end

  def last_trade_time
    last_trade.created_at
  end

  def next_trade_time
    trade_execution_time_limit = RuleConfigService.period_in_seconds(object.change_period)
    ltt = last_trade_time
    ltt + trade_execution_time_limit
  end

  def total_sats_traded
    trades.successful.inject(0) { |mem, var| mem + var.amount } * 1e8
  end
end
