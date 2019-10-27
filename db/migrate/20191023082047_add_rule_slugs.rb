class AddRuleSlugs < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :slug, :string
    add_index :rules, :slug, unique: true
  end
end
