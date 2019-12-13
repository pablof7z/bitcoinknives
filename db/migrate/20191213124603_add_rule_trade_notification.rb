class AddRuleTradeNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :trade_notification, :boolean, default: true
  end
end
