require 'open-uri' 
class Coupon < ActiveRecord::Base
  include ProductsHelper
  attr_protected
  attr_accessor :image_url, :image, :expire_days
  has_attached_file :image, :styles => { :xlarge => "180x180#", :large => "130x130#", :medium => "104x104#", :small => "45x45#" },
    :url => "/images/coupons/:id/:id_:style.jpg"
  before_validation :download_remote_image, :if => :image_url_provided?
  scope :select_with_expire_days , Proc.new{ Coupon.select('coupons.*, datediff(coupons.end_date, now()) as expire_days')}
  scope :recent , Proc.new {Coupon.select_with_expire_days.where("created_at >= SUBDATE(NOW(),2)").order('id DESC')}

  def image_url_provided?
    !self.image_url.blank? 
  end

  def download_remote_image
    self.image = do_download_remote_image
    #self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  def expire_days
    ProductsHelper.getExpireDays(end_date)
  end

  def self.updateHits(id)
    Coupon.update_counters id, :hits => 1
  end
end
