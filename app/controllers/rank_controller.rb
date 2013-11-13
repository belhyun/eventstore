class RankController < ApplicationController
  #include ActionController::Live
  def index
    #response.headers["Content-Type"] = "text/event-stream"
    @products = Product.popularProducts
    title = Array.new   
    @products[0..10].each do |product|  
      hash = Hash.new   
      hash['title'] = product.title   
      title << hash       
    end
    #response.stream.write "data: #{title.to_json}\n\n"
    render :json => title.to_json
=begin
  rescue IOError
    logger.info "Stream closed"
  ensure
    response.stream.close
=end
  end
end
