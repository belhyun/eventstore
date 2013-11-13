json.array!(@groups) do |group|
  json.extract! group, :title, :desc
  json.url group_url(group, format: :json)
end
