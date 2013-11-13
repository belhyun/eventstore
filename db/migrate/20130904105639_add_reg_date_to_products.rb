class AddRegDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :reg_date, :string
    add_column :products, :date, :string
  end
end
