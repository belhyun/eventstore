class RemoveAnnounceFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :announce, :string
  end
end
