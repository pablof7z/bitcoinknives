FactoryBot.define do
  factory :rule, class: Rule do
    exchange_api_key { 'abc' }
    exchange_api_secret { 'abc' }
    change_percentage { 1.0 }
    base_currency { 'USD' }

    user
  end
end
