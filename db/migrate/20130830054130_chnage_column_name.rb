class ChnageColumnName < ActiveRecord::Migration
  def change
    change_table :my_people do |t|
      t.rename :user_id, :buddy_id
    end
  end
end
