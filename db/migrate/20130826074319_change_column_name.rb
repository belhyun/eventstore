class ChangeColumnName < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :detail_link, :link
    end
  end
end
