class AddMayerMultipleRules < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :mayer_multiple, :string
    add_column :rules, :mayer_multiple_value, :decimal
  end
end
