class Category < ActiveRecord::Base
  has_many :product_categories
  has_many :products, through: :product_categories
  validates_presence_of :title, :description
  validates_uniqueness_of :title
end
