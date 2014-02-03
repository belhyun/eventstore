require 'spec_helper'

describe Product do
  it "score by deli" do
    #Product.create!(score: "1000(1), 2000(5)")
  end

  it "multi line to br tag" do
    text = "a\nb\n"
    text.gsub(/\n/,"<br/>")
  end

  it "remove expire products" do
    Product.where("end_date < CURDATE()").each do  |product|
      if product.delete
        $redis.zrem(Rails.application.config.rank_key, product.id)
        system("rm -rf #{File.absolute_path(Rails.root)}/public/images/products/#{product.id}")
      end
    end
  end

  it "urgent_rank_products" do
    Product.urgent.sort{|a,b|
      a.end_date <=> b.end_date || a.score <=> b.score
      #a.score > b.score if a.end_date.eql? b.end_date
    }
  end
end
