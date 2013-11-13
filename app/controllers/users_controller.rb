class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout "product_detail" , :only => :products

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def sign_in

  end

  def refresh_token
    #@users = User.all
    user = User.find(3)
    facebook_oauth ||= Koala::Facebook::OAuth.new(Rails.application.config.facebookid, 
                                                  Rails.application.config.facebooksecret)
    new_token = facebook_oauth.exchange_access_token_info(user.acc_token)
    token_secret = new_token['access_token']
    render :json => User.update(user.id, acc_token: token_secret)

  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def products
    @userProducts = Kaminari.paginate_array(UserProduct.where(:user_id => params[:id])).page(params[:page]).per(10)
    render :html => @userProducts
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:user_id, :name, :image)
    end
end
