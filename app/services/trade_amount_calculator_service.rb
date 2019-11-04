class TradeAmountCalculatorService
  def self.calculate(formula, change_percentage)
    formula = RuleConfigService.formulas_human_to_machine(formula).to_s
    raise "Unknown formula: '#{formula}'" if formula.empty?

    formula.gsub!(/x/, change_percentage.to_s)
    satoshis = eval(formula).abs

    satoshis / 100000000.0
  end
end
