class AddAccTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :acc_token, :text
  end
end
