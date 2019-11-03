class ChangeMaxSatsPerPeriodDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :rules, :max_sats_per_period, 1e6
  end
end
