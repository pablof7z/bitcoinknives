class CreateBitcoinPriceChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :bitcoin_price_changes do |t|
      t.string :base_currency
      t.string :period
      t.decimal :open_price
      t.decimal :close_price

      t.timestamps
    end
  end
end
