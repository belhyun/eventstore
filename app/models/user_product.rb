class UserProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  attr_accessible :product_id, :user_id
  scope :getZzimCnt, lambda{|id| UserProduct.count(:conditions => "product_id=#{id}")}
end
