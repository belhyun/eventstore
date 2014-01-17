class RemoveColumn < ActiveRecord::Migration
  def change
    remove_column :products, :ex_id
    remove_column :products, :enterprise_id
    remove_column :products, :place
    remove_column :products, :latitude
    remove_column :products, :longitude
    remove_column :products, :announce
  end
end
