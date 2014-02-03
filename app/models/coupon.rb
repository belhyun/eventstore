require 'open-uri' 
class Coupon < ActiveRecord::Base
  attr_protected
  attr_accessor :image_url, :image
  has_attached_file :image, :styles => { :xlarge => "180x180#", :large => "130x130#", :medium => "104x104#", :small => "45x45#" },
    :url => "/images/coupons/:id/:id_:style.jpg"
  before_validation :download_remote_image, :if => :image_url_provided?

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
end
