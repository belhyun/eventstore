json.array!(@group_products) do |group_product|
  json.extract! group_product, :group_id, :product_id
  json.url group_product_url(group_product, format: :json)
end
