class AddUserUpgraded < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :btcpay_invoice_id
    add_column :users, :upgraded, :boolean, default: false
  end
end
