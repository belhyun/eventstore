class DropLogsTable < ActiveRecord::Migration
  def change
    drop_table :logs
  end
end
