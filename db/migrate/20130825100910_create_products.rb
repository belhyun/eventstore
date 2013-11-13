class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :publisher
      t.text :title
      t.string :join_method
      t.text :detail_link
      t.string :category

      t.timestamps
    end
  end
end
