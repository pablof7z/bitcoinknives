$:.unshift File.dirname(__FILE__)
$:.unshift "#{File.dirname(__FILE__)}/lib"
$:.unshift "#{Rails.root}/app/policies"

require "rules_query"
require "rule_trader_policy"
require "rule_trader_service"
require "#{Rails.root}/config/initializers/raven"

loop do
  bitcoin_prices = BitcoinPriceChange.all.to_h {|bpc| [bpc.period, bpc]}

  rules_to_trade_queue = []

  RulesQuery.ready_to_trade.each do |rule|
    if RuleTraderPolicy.should_execute_trade?(rule, bitcoin_prices[rule.change_period])
      rules_to_trade_queue << rule
    end
  end

  if rules_to_trade_queue.any?
    trader_service = RuleTraderService.new(rules_to_trade_queue, bitcoin_prices)
    trader_service.trade!
  end

  sleep(10)
end
