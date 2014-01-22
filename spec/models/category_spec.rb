require 'spec_helper'

describe Category do
 #category = FactoryGirl.create(:category) 
 
  it "get_category_products" do 
    Category.products(11).should_not be_nil
  end
end
