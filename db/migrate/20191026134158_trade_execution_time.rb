class TradeExecutionTime < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :executed_at, :datetime
  end
end
