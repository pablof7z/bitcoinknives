class CreateTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.references :rule, null: false, foreign_key: true
      t.decimal :change_percentage
      t.decimal :amount
      t.decimal :price

      t.timestamps
    end
  end
end
