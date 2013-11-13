json.array!(@enterprises) do |enterprise|
  json.extract! enterprise, :title, :desc
  json.url enterprise_url(enterprise, format: :json)
end
