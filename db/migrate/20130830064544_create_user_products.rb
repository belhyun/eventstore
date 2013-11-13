class CreateUserProducts < ActiveRecord::Migration
  def change
    create_table :user_products do |t|
      t.integer :user_id
      t.integer :prodcut_id

      t.timestamps
    end
  end
end
