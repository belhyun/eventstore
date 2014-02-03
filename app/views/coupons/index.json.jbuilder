json.array!(@coupons) do |coupon|
  json.extract! coupon, :link, :start_date, :end_date, :gift, :gift_type, :description, :hits, :is_premium
  json.url coupon_url(coupon, format: :json)
end
