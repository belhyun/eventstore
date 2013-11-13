class AddEnterpriseIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :enterprise_id, :integer
  end
end
