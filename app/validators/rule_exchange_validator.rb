require 'exchanges/kraken'

class RuleExchangeValidator
  def self.valid?(rule)
    k = case rule.exchange_name
    when 'kraken' then Exchanges::Kraken
    else
      raise "Unknown exchange #{rule.exchange_name}"
    end

    client = k.new
    return client.valid_api_key?
  end
end
