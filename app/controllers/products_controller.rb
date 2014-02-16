class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_popular_product, only: [:story, :rank, :urgent, :recent, :search]
  before_action :set_categories, only: [:story, :rank, :urgent, :recent, :search]
  before_action :set_type, only: [:story, :rank, :urgent, :recent]
  before_action :set_current_user_js, only: [:show]
  layout "product_show" , :only => :show
  protect_from_forgery :except => :create

  # GET /products
  # GET /products.json
  def index
  end

  def search
    @search = Product.search(params).result
    respond_to do |format|
      format.html 
      format.json { render json: @search.result.to_json}
    end
  end

  def story
    totalGroups = Group.all.order('created_at DESC') + Category.all.order("created_at DESC")
    @groups = Kaminari.paginate_array(totalGroups).page(params[:page]).per(10)
    gon.total_cnt = totalGroups.count
    respond_to do |format|
      format.html 
      format.json { render json: @groups.to_json(:include => :products)}
    end
  end

  def urgent
    urgent = Product.urgent
    @products = Kaminari.paginate_array(urgent).page(params[:page]).per(10)
    gon.total_cnt = urgent.count
    respond_to do |format|
      format.html 
      format.json { render json: @products.to_json}
    end
  end

  def rank
    totalProducts = Product.popularProducts
    @products = Kaminari.paginate_array(totalProducts).page(params[:page]).per(10)
    gon.total_cnt = totalProducts.count
    respond_to do |format|
      format.html 
      format.json { render json: @products.to_json}
    end
  end

  def recent
    recent = Product.recent
    @products = Kaminari.paginate_array(recent).page(params[:page]).per(10)
    gon.total_cnt = recent.count
    respond_to do |format|
      format.html 
      format.json { render json: @products.to_json}
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    Product.updateHits(params[:id])
    @zzimCnt = UserProduct.get_zzim_cnt(params[:id])
    @userProduct = UserProduct.where(:user_id => current_user.id, :product_id => params[:id]).first unless current_user.nil?
    gon.userProduct = @userProduct 
    gon.product = Product.find(params[:id])
  end

  def test
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def recommend
    if !current_user.nil?
      @recommendProducts = Product.recommendProducts(current_user.id)
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_popular_product
      @rankProducts = Kaminari.paginate_array(Product.popularProducts).page(params[:page]).per(100)
    end

    def set_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def set_type
      @type = params[:action]
      @type ||= 'group'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params[:product]
    end

    def set_categories
      @categories = Category.all
    end

    def set_current_user_js
      gon.current_user = current_user
    end
end
