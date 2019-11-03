require 'exchanges/kraken'

class RuleExchangeValidator
  def self.valid?(rule)
    k = case rule.exchange_name
    when 'kraken' then Exchanges::Kraken
    else
      raise "Unknown exchange #{rule.exchange_name}"
    end

    client = k.new(
      api_key: rule.exchange_api_key,
      api_secret: rule.exchange_api_secret,
    )
    return client.valid_api_key?
  end
end
