class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.string :currency, default: 'BTC'
      t.string :status
      t.string :btcpay_invoice_id
      t.string :slug

      t.timestamps
    end
  end
end
