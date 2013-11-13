class ChangeUserProductsColumnName < ActiveRecord::Migration
  def change
    change_table :user_products do |t|
      t.rename :prodcut_id, :product_id
    end
  end
end
