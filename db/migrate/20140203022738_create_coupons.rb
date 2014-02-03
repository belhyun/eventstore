class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.text :link
      t.date :start_date
      t.date :end_date
      t.text :gift
      t.text :gift_type
      t.text :description
      t.integer :hits
      t.integer :is_premium

      t.timestamps
    end
  end
end
