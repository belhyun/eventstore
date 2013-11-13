class AddHitsToProduct < ActiveRecord::Migration
  def change
    change_column :products, :hits, :default => 0
  end
end
