json.array!(@users) do |user|
  json.extract! user, :user_id, :name, :image
  json.url user_url(user, format: :json)
end
