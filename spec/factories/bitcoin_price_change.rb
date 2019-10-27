FactoryBot.define do
  factory :bitcoin_price_change do
    open_price { 10.0 }
    close_price { 5.0 }
    period { '24 hours' }
  end
end
