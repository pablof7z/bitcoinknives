class BitcoinPriceChange < ApplicationRecord
  validates :open_price, :close_price, :period, presence: true
  before_save :calculate_change_percentage

  def calculate_change_percentage
    self.change_percentage = ((close_price/open_price)-1)*100
  end
end
