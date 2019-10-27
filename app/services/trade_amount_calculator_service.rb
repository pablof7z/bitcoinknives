class TradeAmountCalculatorService
  def self.calculate(trade, bitcoin_price_change)
    formula = RuleConfigService.formulas_human_to_machine(trade.rule_formula).to_s
    raise "Unknown formula: #{trade.rule_formula}" if formula.empty?

    formula.gsub!(/x/, bitcoin_price_change.change_percentage.to_s)
    satoshis = eval(formula).abs

    satoshis / 100000000.0
  end
end
