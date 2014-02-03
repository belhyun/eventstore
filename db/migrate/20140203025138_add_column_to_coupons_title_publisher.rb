class AddColumnToCouponsTitlePublisher < ActiveRecord::Migration
  def change
    add_column :coupons, :title, :text
    add_column :coupons, :publisher, :string
  end
end
