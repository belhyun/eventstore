class RenameuserProducts < ActiveRecord::Migration
  def change
      rename_table :user_products, :userProducts
  end
end
