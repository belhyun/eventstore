module ProductsHelper
  def self.redis_key(id, str)
    "USER:#{id}:#{str}"
  end

  def self.getExpireDays(time)
    if !time.nil?
      diffDays = (((Time.zone.now - time.to_time)/1.day)-1).to_i.abs.to_s
    else
      diffDays = '만료정보 없음'
    end
  end
end
