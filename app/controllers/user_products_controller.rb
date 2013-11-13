class UserProductsController < ApplicationController
  before_action :set_user_product, only: [:show, :edit, :update, :destroy]

  # GET /user_products
  # GET /user_products.json
  def index
    if current_user
      @userProducts = UserProduct.find(:all, :conditions => {:user_id => current_user.id})
    end
  end

  # GET /user_products/1
  # GET /user_products/1.json
  def show
  end

  # GET /user_products/new
  def new
    @user_product = UserProduct.new
  end

  # GET /user_products/1/edit
  def edit
  end

  # POST /user_products
  # POST /user_products.json
  def create
    if !UserProduct.where(:user_id => user_product_params[:user_id], :product_id => user_product_params[:product_id]).all.blank?
      render(:json => {:status => 403 }) and return
    end
    @user_product = UserProduct.new(user_product_params)
    respond_to do |format|
      if @user_product.save
        #RecommendWorker.perform_async(@user_product.id)
        if !user_product_params[:product_id].nil?
          Product.addScoreToProduct(user_product_params[:product_id], 5)
        end
        format.html { redirect_to @user_product, notice: 'User product was successfully created.' }
        format.json { render json: @user_product, status: :created}
      else
        format.html { render action: 'new' }
        format.json { render json: @user_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_products/1
  # PATCH/PUT /user_products/1.json
  def update
    respond_to do |format|
      if @user_product.update(user_product_params)
        format.html { redirect_to @user_product, notice: 'User product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_products/1
  # DELETE /user_products/1.json
  def destroy
    if !@user_product.nil?
      Product.addScoreToProduct(@user_product.product.id, -100)
    end
    @user_product.destroy
    respond_to do |format|
      format.html { redirect_to user_products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_product
      @user_product = UserProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_product_params
      params.require(:user_product).permit(:user_id, :product_id)
    end
end
