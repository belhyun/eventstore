class ChangeColumnCouponsIsPremium < ActiveRecord::Migration
  def change
    change_column :coupons, :is_premium, :boolean
  end
end
