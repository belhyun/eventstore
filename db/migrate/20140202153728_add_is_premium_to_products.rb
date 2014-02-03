class AddIsPremiumToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_premium, :boolean
  end
end
