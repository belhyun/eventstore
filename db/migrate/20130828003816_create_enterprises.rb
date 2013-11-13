class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.string :title
      t.text :desc

      t.timestamps
    end
  end
end
