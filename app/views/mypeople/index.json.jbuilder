json.array!(@mypeople) do |myperson|
  json.extract! myperson, 
  json.url myperson_url(myperson, format: :json)
end
