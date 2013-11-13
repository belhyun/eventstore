class ChangeRegDateToDateTime < ActiveRecord::Migration
  def change
    change_column :products, :reg_date, :datetime
  end
end
