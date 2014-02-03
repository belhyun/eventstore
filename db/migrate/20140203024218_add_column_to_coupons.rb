class AddColumnToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :image_file_name, :text
    add_column :coupons, :image_content_type, :text
    add_column :coupons, :image_file_size, :integer
    add_column :coupons, :image_updated_at, :date
    add_column :coupons, :image_url, :text
  end
end
