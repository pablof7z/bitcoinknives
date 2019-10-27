class RuleConfigService
  class << self
    def method_missing(m)
      YAML.load_file("#{Rails.root}/config/rule_configs.yml")[m.to_s]
    end

    def formulas_human
      YAML.load_file("#{Rails.root}/config/rule_configs.yml")['formulas'].keys
    end

    def formulas_human_to_machine(human_format)
      YAML.load_file("#{Rails.root}/config/rule_configs.yml")['formulas'][human_format]
    end

    def periods
      YAML.load_file("#{Rails.root}/config/price_fetcher.yml")['periods'].keys
    end

    def period_in_seconds(period)
      period_exp = YAML.load_file("#{Rails.root}/config/price_fetcher.yml")['periods'][period]
      eval(period_exp)
    end
  end
end
