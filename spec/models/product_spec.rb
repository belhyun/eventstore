require 'spec_helper'

describe Product do
  it "score by deli" do
    #Product.create!(score: "1000(1), 2000(5)")
  end

  it "multi line to br tag" do
    text = "a\nb\n"
    text.gsub(/\n/,"<br/>")
  end
end
