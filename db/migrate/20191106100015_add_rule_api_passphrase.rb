class AddRuleApiPassphrase < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :exchange_api_passphrase, :string
  end
end
