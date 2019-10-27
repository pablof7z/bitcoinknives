class AddRuleBaseCurrency < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :base_currency, :string, default: 'USD'
  end
end
