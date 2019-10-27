FactoryBot.define do
  factory :trade, class: Trade do
    rule
  end

  factory :trade_outside_period, parent: :trade do
    executed_at { 1.year.ago }
  end

  factory :trade_within_period, parent: :trade do
    executed_at { 1.minute.ago }
  end
end
