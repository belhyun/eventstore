require 'open-uri'
class Product < ActiveRecord::Base
  include ProductsHelper
  has_many :users, through: :user_products
  has_many :user_products
  has_many :groups, through: :group_products
  has_many :group_products
  has_many :categories, through: :product_categories
  has_many :product_categories
  attr_protected
  attr_accessor :image_url, :image, :expire_days
  has_attached_file :image, :styles => { :xlarge => "180x180#", :large => "130x130#", :medium => "104x104#", :small => "45x45#" },
    :url => "/images/products/:id/:id_:style.jpg"
  before_validation :download_remote_image, :if => :image_url_provided?
  after_create :reg_rank_table
  after_update :reg_rank_table
  scope :urgent, lambda {Product.select('products.*,datediff(products.end_date, now()) as expire_days').where("end_date >= SUBDATE(NOW(),1)").order("end_date asc")}
  scope :total , lambda {Product.where("end_date >= SUBDATE(NOW(),1)").order('id DESC')}
  scope :recent , Proc.new {Product.where("created_at >= SUBDATE(NOW(),2)").order('id DESC')}

  def reg_rank_table
    Product.addScoreToProduct(id,score)
  end

  def score=(score)
    @total = 0
    score.scan(/\d+\(\d+\)/).each do |score|
      /(\d+)\((\d)\)/.match(score){|m|
        @total += m[1].to_i * m[2].to_i
      }
    end
  end

  def score
    @total
  end

  def self.products
    products = self.select('products.*, count(user_products.id) as evented_cnt').joins('left join user_products on products.id = user_products.product_id')
    .group('products.id').order("products.id ASC").order("evented_cnt DESC")
    products
  end

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

  def self.popularProducts
    rankProducts = $redis.zrevrange(Rails.application.config.rank_key, 0 ,-1).reverse
    products = Product.select('products.*,datediff(products.end_date, now()) as expire_days')
    .where("products.id in (:ids) and products.end_date >= now()",:ids =>rankProducts)
    products = products.sort_by do |element|
      rankProducts.index(element.id.to_s)
    end
    products.reverse   
  end

  def self.addScoreToProduct(id, score)
    if $redis.zscore(Rails.application.config.rank_key, id).nil?
      $redis.zadd(Rails.application.config.rank_key, score, id)
    else
      $redis.zincrby(Rails.application.config.rank_key, score, id)
    end
  end

  def self.updateProductsScoreByTime
    products = Product.all
    products.each do |product|
      $redis.zincrby(Rails.application.config.rank_key, -3, product.id)
    end
  end

  def self.removeExpireProducts
    Product.where("end_date < CURDATE()").each do  |product|
      $redis.zrem(Rails.application.config.rank_key, product.id)
    end
    GroupProduct.removeExpireProducts
  end

  def self.updateHits(id)
    Product.update_counters id, :hits => 1
  end
end
