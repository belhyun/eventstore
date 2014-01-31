class CategoriesController < ApplicationController
  layout "categories" , :only => :show
  before_action :set_category
  before_action :set_popular_products

  def show
    @category_products = Category.products(params[:id])
    @products = Kaminari.paginate_array(@category_products).page(params[:page]).per(5)
    gon.total_cnt = @category_products.count
    respond_to do |format|
      format.html 
      format.json { render json: @products.to_json}
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end
  def set_popular_products
    @rankProducts = Kaminari.paginate_array(Product.popularProducts).page(params[:page]).per(50)
  end
end
