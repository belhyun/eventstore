FactoryGirl.define do
  factory :category do
    title 'test'
    description 'this is category test'
  end

  factory :Product_category do
    product_id 77990
    category_id 7
  end
end
