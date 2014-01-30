class CategoriesController < ApplicationController
  layout "categories" , :only => :show
  before_action :set_category
  before_action :set_popular_products

  def show
    @products = Category.products(params[:id])
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end
  def set_popular_products
    @rankProducts = Kaminari.paginate_array(Product.popularProducts).page(params[:page]).per(50)
  end
end
