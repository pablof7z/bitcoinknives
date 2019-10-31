class Invoice < ApplicationRecord
  extend FriendlyId
  friendly_id :uuid, use: [:slugged, :finders]
  belongs_to :user

  validates :user_id, presence: true
  validates :slug, presence: true
  validates :amount, numericality: true

  def uuid
    @uuid ||= SecureRandom.uuid
  end
end
