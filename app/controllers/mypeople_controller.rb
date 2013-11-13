class MypeopleController < ApplicationController
  #before_action :set_myperson, only: [:show, :edit, :update, :destroy]

  # GET /mypeople
  # GET /mypeople.json
  protect_from_forgery except: [:callback, :send]

  def index
    @mypeople = Myperson.all
  end

  def callback
    if !params[:buddyId].nil?
      Myperson.find_or_create_by_buddy_id(:buddy_id => params[:buddyId])
    end
    render nothing: true
  end

  # GET /mypeople/1
  # GET /mypeople/1.json
  def show
  end

  # GET /mypeople/new
  def new
    @myperson = Myperson.new
  end

  # GET /mypeople/1/edit
  def edit
  end

  # POST /mypeople
  # POST /mypeople.json
  def create
    @myperson = Myperson.new(myperson_params)

    respond_to do |format|
      if @myperson.save
        format.html { redirect_to @myperson, notice: 'Myperson was successfully created.' }
        format.json { render action: 'show', status: :created, location: @myperson }
      else
        format.html { render action: 'new' }
        format.json { render json: @myperson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mypeople/1
  # PATCH/PUT /mypeople/1.json
  def update
    respond_to do |format|
      if @myperson.update(myperson_params)
        format.html { redirect_to @myperson, notice: 'Myperson was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @myperson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mypeople/1
  # DELETE /mypeople/1.json
  def destroy
    @myperson.destroy
    respond_to do |format|
      format.html { redirect_to mypeople_url }
      format.json { head :no_content }
    end
  end

  def send_msg
    product = Product.top_product
    buddies = Myperson.all
    result = Array.new
    puts product.inspect
    url = url_for :controller => 'products' , :action => 'show' ,:id => product.id
    msg = "이벤트모아에서 알려드리는 핫 이벤트 소식\n이벤트명:#{product.title}\n연결링크:#{url}"
    buddies.each do |buddy|
      if !buddy[:buddy_id].nil?
        RestClient.post "https://apis.daum.net/mypeople/buddy/send.json", {'buddyId' => buddy[:buddy_id], 'content' => msg, 'apikey'=> '77529416283d858440d5fd3ecc43e9c8b464f431' }, :content_type =>'application/x-www-form-urlencoded' , :accept => "json"
      end
    end
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_myperson
      @myperson = Myperson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def myperson_params
      params[:myperson]
    end
end
