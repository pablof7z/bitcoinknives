class Trade < ApplicationRecord
  belongs_to :rule
  has_one :user, through: :rule

  delegate :change_period,
           :formula,
           :base_currency,
           :exchange_name,
           :exchange_api_key,
           :exchange_api_secret,
           :slug,
           to: :rule, prefix: true

  delegate :id,
           to: :user, prefix: true
end
