Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, '503029133125134', '59f3c163044b21ec5bed838434ca7988'
end
