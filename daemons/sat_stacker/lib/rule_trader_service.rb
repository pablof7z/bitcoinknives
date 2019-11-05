require_relative "trade_executer"

class RuleTraderService
  attr_reader :rules

  def initialize(rules, bitcoin_prices)
    @rules = rules
    @bitcoin_prices = bitcoin_prices
  end

  def trade!
    grouped_rules = rules.group_by {|r| r.user.has_paid_plan? }
    grouped_rules[true].each {|r| trade_rule(r) } if grouped_rules[true]
    grouped_rules[false].each {|r| trade_rule(r) } if grouped_rules[false]
  end

  def trade_rule(rule)
    trade = rule.trades.new
    trade.change_percentage = @bitcoin_prices[rule.change_period].change_percentage
    trade.amount = calculate_trade_amount(trade)
    trade.save

    te = TradeExecuter.new(trade)
    te.execute!
  rescue => e
    Raven.capture_message("Failed trade execution: #{rule.id}", extra: {error: e.message, backtrace: e.backtrace})
    raise
  end

  def calculate_trade_amount(trade)
    amount = TradeAmountCalculatorService.calculate(
      trade.rule_formula,
      @bitcoin_prices[trade.rule_change_period].change_percentage
    )
    trade.amount = amount
  rescue => e
    trade.update(
      message: e.message,
      tx_status: TradeResult::STATUS::Failed,
    )
  end
end
