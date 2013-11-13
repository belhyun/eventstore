class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :title
      t.text :desc

      t.timestamps
    end
  end
end
