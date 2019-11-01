class Rule < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]
  belongs_to :user
  has_many :trades

  validates :change_percentage, numericality: true
  validates :base_currency, presence: true
  validates :exchange_name, inclusion: { in: RuleConfigService.exchanges, message: 'is not valid' }
  validates :formula, inclusion: { in: RuleConfigService.formulas_human, message: 'is not valid' }
  validate :exchange_api_key_details, if: -> { exchange_name? }

  scope :enabled, -> { where(enabled: true) }
  scope :configured, -> { where.not(exchange_name: nil, exchange_api_key: nil, exchange_api_secret: nil) }

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def configured?
    exchange_name && exchange_api_key && exchange_api_secret
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
    if exchange_name
      if !RuleExchangeValidator.valid?(self)
        errors.add(:base, I18n.t('rule.validations.invalid_api_key'))
      end
    end
  end
end
