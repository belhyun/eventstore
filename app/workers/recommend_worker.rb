class RecommendWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    userProduct = UserProduct.find_by_id(id) 
    if !$redis.sismember(self.redis_key(userProduct.user_id,"PRODUCTS"))
      $redis.sadd(self.redis_key(userProduct.user_id,"PRODUCTS"),userProduct.product_id)
    end
  end

  def redis_key(id, str)
    "USER:#{id}:#{str}"
  end
end
