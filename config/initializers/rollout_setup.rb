$redis = Redis.new
$rollout = Rollout.new($redis)
$rollout.define_group(:admin) do |user|
  user.admin?
end
