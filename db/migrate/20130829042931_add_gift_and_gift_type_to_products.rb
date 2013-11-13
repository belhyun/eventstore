class AddGiftAndGiftTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :gift, :text
    add_column :products, :gift_type, :text
  end
end
