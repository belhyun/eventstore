class CouponsController < InheritedResources::Base
  before_action :set_popular_products
  before_action :set_categories
  before_action :set_type
  layout "coupon_show" , :only => :show
  def index
    @coupons = Kaminari.paginate_array(Coupon.select_with_expire_days.recent).page(params[:page]).per(10)
    gon.total_cnt = @coupons.count
    respond_to do |format|
      format.html 
      format.json { render json: @coupons.to_json}
    end
  end

  def show
    Coupon.updateHits(params[:id])
    @coupon = Coupon.find(params[:id])
=begin
    @zzimCnt = UserProduct.getZzimCnt(params[:id])
    if !current_user.nil?
      @userProduct = UserProduct.where(:user_id => current_user.id, :product_id => params[:id]).first
      @user = User.find(current_user.id)
    end
=end
  end


  private
  def set_popular_products
    @rankProducts = Kaminari.paginate_array(Product.popularProducts).page(params[:page]).per(50)
  end

  def set_categories
    @categories = Category.all
  end

  def set_type
    @type = params[:action]
    @type ||= 'group'
  end
end
