class AddTradeExecutionInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :tx_info, :string
    add_column :trades, :tx_id, :string
    add_column :trades, :tx_status, :string
  end
end
