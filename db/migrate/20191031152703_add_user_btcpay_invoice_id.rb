class AddUserBtcpayInvoiceId < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :btcpay_invoice_id, :string
  end
end
