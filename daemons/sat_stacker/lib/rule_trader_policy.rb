class RuleTraderPolicy
  def self.should_execute_trade?(rule, bitcoin_price_change)
    rule.change_percentage <= bitcoin_price_change.change_percentage.abs
  end
end
