class CreateGroupProducts < ActiveRecord::Migration
  def change
    create_table :group_products do |t|
      t.integer :group_id
      t.integer :product_id

      t.timestamps
    end
  end
end
