FactoryBot.define do
  factory :rule, class: Rule do
    exchange_name { 'kraken' }
    exchange_api_key { 'abc' }
    exchange_api_secret { 'abc' }
    change_percentage { 1.0 }
    base_currency { 'USD' }
    formula {'1 btc'}
    enabled { true }
    max_sats_per_trade { '1 btc' }
    max_sats_per_period { '1 btc' }

    user
  end
end
