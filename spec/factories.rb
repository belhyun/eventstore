FactoryGirl.define do
  factory :product do
    score "1000000(1), 20000(5)"
    sequence(:id)
  end
end
