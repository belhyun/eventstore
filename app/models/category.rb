class Category < ActiveRecord::Base
  has_many :product_categories
  has_many :products, through: :product_categories
  attr_protected
  validates_uniqueness_of :title
  validates_presence_of :title, :description
  scope :products, Proc.new {|id| Category.find(id).products}
end
