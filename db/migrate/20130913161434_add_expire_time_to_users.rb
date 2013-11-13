class AddExpireTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expire, :string
  end
end
