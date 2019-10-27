require "trade_executer"

class RuleTraderService
  attr_reader :rules

  def initialize(rules, bitcoin_prices)
    @rules = rules
    @bitcoin_prices = bitcoin_prices
  end

  def trade!
    threads = rules.map {|r| Thread.new { trade_rule(r) }}
    threads.join
  end

  def trade_rule(rule)
    trade = rule.trades.new
    trade.change_percentage = @bitcoin_prices[rule.change_period].change_percentage
    trade.amount = calculate_trade_amount(trade)
    trade.save

    te = TradeExecuter.new(trade)
    te.execute!
  end

  def calculate_trade_amount(trade)
    amount = TradeAmountCalculatorService.calculate(trade, @bitcoin_prices[trade.rule_change_period])
    trade.amount = amount
  end
end
