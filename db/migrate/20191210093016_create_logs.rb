class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.string :message
      t.string :backtrace
      t.string :severity

      t.timestamps
    end
  end
end
