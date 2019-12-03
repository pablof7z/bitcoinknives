require "exchanges"

class RuleExchangeValidator
  def self.valid?(rule)
    k = case rule.exchange_name
    when 'kraken' then Exchanges::Kraken
    when 'coinbase pro' then Exchanges::CoinbasePro
    else
      raise "Unknown exchange #{rule.exchange_name}"
    end

    client = k.new(
      api: {
        key: rule.exchange_api_key,
        secret: rule.exchange_api_secret,
        passphrase: rule.exchange_api_passphrase,
      }
    )
    return client.valid_api_key?
  end
end
