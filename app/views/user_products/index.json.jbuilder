json.array!(@user_products) do |user_product|
  json.extract! user_product, :user_id, :prodcut_id
  json.url user_product_url(user_product, format: :json)
end
