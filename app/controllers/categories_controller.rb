class CategoriesController < ApplicationController
  layout "categories" , :only => :show
  def show
    @products = Category.products(params[:id])
  end
end
