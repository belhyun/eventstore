class AddProductIdToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :product_id, :integer
  end
end
