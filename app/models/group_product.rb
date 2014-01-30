class GroupProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :group
  attr_accessible :product_id, :group_id
  
  def self.groupProducts
    result = Array.new
    Group.all.each do |group|
      result << group.products
    end
    result
  end
  
  def self.getGroupProductsCnt
    groups = Group.all
    hitsCount = Array.new
    groups.each do |group|
      products = group.products
      productCnt = 0
      products.each do |product|
        productCnt += product.hits
      end
      hitsCount << productCnt
    end
    hitsCount
  end

  def self.removeExpireProducts
    groupProducts = GroupProduct.all
    groupProducts.each do |groupProduct|
      groupProduct.delete if !groupProduct.product.nil? && groupProduct.product.end_date.to_time < Time.zone.now
    end
  end
end
