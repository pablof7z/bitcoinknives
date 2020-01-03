class TradeAmountCalculatorService
  def self.calculate(rule, change_percentage)
    formula = RuleConfigService.formulas_human_to_machine(rule.formula).to_s
    raise "Unknown formula: '#{formula}'" if formula.empty?

    formula.gsub!(/x/, change_percentage.to_s)
    sats = eval(formula).abs

    sats_in_btc([
      sats,
      rule.max_sats_per_trade,
      rule.sats_available_for_trade_in_period,
    ].min)
      .round(5)
  end

  def self.sats_in_btc(sats)
    sats / 100_000_000.0
  end
end
