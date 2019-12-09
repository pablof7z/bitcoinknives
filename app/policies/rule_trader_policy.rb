class RuleTraderPolicy
  class << self
    def should_execute_trade?(rule, bitcoin_price_change)
      sufficient_price_change?(rule, bitcoin_price_change) &&
      rule_within_trade_limits?(rule) &&
      !rule_traded_within_change_period?(rule)
    end

    def sufficient_price_change?(rule, bitcoin_price_change)
      rule.change_percentage <= bitcoin_price_change.change_percentage.abs
    end

    def rule_within_trade_limits?(rule)
      period_limit = RuleConfigService.period_in_seconds(rule.max_sats_per_period_length)
      traded_within_period_limit = rule.total_sats_traded_in_period

      rule.max_sats_per_period > traded_within_period_limit
    end

    def rule_traded_within_change_period?(rule)
      period_limit = RuleConfigService.period_in_seconds(rule.change_period)
      rule.trades
        .successful
        .where('created_at >= ?', period_limit.ago)
        .any?
    end
  end
end
