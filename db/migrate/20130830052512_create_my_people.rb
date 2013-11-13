class CreateMyPeople < ActiveRecord::Migration
  def change
    create_table :my_people do |t|
      t.string :user_id
    end
  end
end
