class Rule < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]
  belongs_to :user
  has_many :trades

  validates :change_percentage, numericality: true
  validates :base_currency, presence: true

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
end