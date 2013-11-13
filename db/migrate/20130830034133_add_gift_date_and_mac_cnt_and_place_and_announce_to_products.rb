class AddGiftDateAndMacCntAndPlaceAndAnnounceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :gift_date, :string
    add_column :products, :max_cnt, :string
    add_column :products, :place, :string
    add_column :products, :announce, :string
  end
end
