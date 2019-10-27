class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.references :user, null: false, foreign_key: true
      t.float :change_percentage
      t.string :change_period, default: '24 hours'
      t.string :formula
      t.integer :max_sats_per_trade, default: 10000000
      t.integer :max_sats_per_period, default: 100000000
      t.integer :max_period_in_secs, default: 1.month.to_i
      t.boolean :enabled, default: true
      t.string :exchange_name
      t.string :exchange_api_key
      t.string :exchange_api_secret

      t.timestamps
    end
  end
end
