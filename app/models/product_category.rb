class ProductCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :product
  validates_associated :product, :category
  attr_protected
end
