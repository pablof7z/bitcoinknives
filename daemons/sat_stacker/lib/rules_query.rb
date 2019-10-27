require "rule_trader_policy"

class RulesQuery
  def self.ready_to_trade
    Rule
      .enabled
      .configured
      .select {|r| r.tradable?}
  end
end
