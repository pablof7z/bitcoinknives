class ChangeDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :rules, :max_sats_per_trade, 1e6
    change_column_default :rules, :max_sats_per_period, 2.5e6
  end
end
