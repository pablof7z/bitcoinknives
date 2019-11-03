class ChangeRuleLimits < ActiveRecord::Migration[6.0]
  def change
    remove_column :rules, :max_period_in_secs
    add_column :rules, :max_sats_per_period_length, :string, default: '1 week'
  end
end
