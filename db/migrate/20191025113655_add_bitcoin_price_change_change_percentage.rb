class AddBitcoinPriceChangeChangePercentage < ActiveRecord::Migration[6.0]
  def change
    add_column :bitcoin_price_changes, :change_percentage, :decimal
  end
end
