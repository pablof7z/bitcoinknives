class Rule < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]
  belongs_to :user
  has_many :trades

  validates :change_percentage, numericality: true
  validates :base_currency, presence: true
  validates :exchange_name, inclusion: { allow_blank: true, in: RuleConfigService.exchanges, message: 'is not valid' }
  validates :formula, inclusion: { in: RuleConfigService.formulas_human, message: 'is not valid' }
  validate :exchange_api_key_details, if: -> { exchange_api_key? && exchange_api_secret? }
  validate :max_sats_per_trade_limit, if: -> { exchange_name? }

  scope :enabled, -> { where(enabled: true) }
  scope :configured, -> { where.not(exchange_name: nil, exchange_api_key: nil, exchange_api_secret: nil) }

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def configured?
    !exchange_name.blank? || !exchange_api_key.blank? || !exchange_api_secret.blank?
  end

  def running?
    enabled? && configured?
  end

  def total_traded
    trades.inject(0) { |mem, var| mem + var.amount }
  end

  def tradable?
    trade_execution_time_limit = RuleConfigService.period_in_seconds(change_period).ago
    trades.where('executed_at > ?', trade_execution_time_limit).empty?
  end

  private

  def exchange_api_key_details
    if !RuleExchangeValidator.valid?(self)
      errors.add(:base, I18n.t('rule.validations.invalid_api_key'))
    end
  end

  def max_sats_per_trade_limit
    min_amount = RuleConfigService.trade_limit_for(exchange_name, type: 'min').to_f

    if min_amount > max_sats_per_trade
      errors.add(:max_sats_per_trade, "is too low, #{exchange_name}'s minimum purchase is #{min_amount.to_i} sats")
      self.max_sats_per_trade = min_amount.to_i
    end
  end
end
