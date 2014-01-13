class Group < ActiveRecord::Base
  has_many :group_products, dependent: :destroy
  has_many :products, through: :group_products 
  validates_presence_of :title, :desc
  attr_accessible :title, :desc, :tag_list, :id, :products_cnt
  attr_accessor :products_cnt
  acts_as_taggable

  after_create :make_group_products
  after_update :make_group_products

  private
  def make_group_products
    products = Array.new
    tag_list.each do |tag|
      sql = Product.where("end_date >= CURDATE() AND (title like ? or gift like ? or description like ?)", "%#{tag}%", "%#{tag}%", "%#{tag}%").to_sql
      Product.find_by_sql(sql).each do |product|
        if !products.include? product
          products << product
        end
      end
    end
    products.each do |product|
      GroupProduct.find_or_create_by(
        :group_id => id,
        :product_id =>product.id
      )
    end
  end
end
