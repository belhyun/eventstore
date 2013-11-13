class AddExIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ex_id, :integer
  end
end
