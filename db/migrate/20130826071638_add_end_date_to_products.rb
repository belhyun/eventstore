class AddEndDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :end_date, :date
  end
end
