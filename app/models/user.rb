class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  has_many :products, through: :user_products
  has_many :user_products
  attr_protected

  def self.find_or_create_from_auth_hash(auth)
    #user = self.where(fbusn: auth.uid).first
    #unless user
      user = User.find_or_create_by_email(
        fbusn: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        image: "https://graph.facebook.com/#{auth.info.nickname}/picture?type=large"
      )
      user
  end

  def self.refreshToken
    user = User.find(3)
    facebook_oauth ||= Koala::Facebook::OAuth.new(Rails.application.config.facebookid, 
                                                  Rails.application.config.facebooksecret)
    new_token = facebook_oauth.exchange_access_token_info(user.acc_token)
    token_secret = new_token['access_token']
    User.update(user.id, acc_token: token_secret)
  end
end
