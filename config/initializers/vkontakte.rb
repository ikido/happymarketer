VkontakteApi.configure do |config|
  config.app_id       = ENV['VK_APP_ID']
  config.app_secret   = ENV['VK_APP_SECRET']
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'
  config.log_errors    = true
end

# 1) scope = [:audio, :video, :photos, :friends, :pages, :wall, :groups, :stats, :ads, :offline]
# 2) VkontakteApi.authorization_url(type: :client, scope: scope)
# 3) action at /vk_oauth_callback reads params[:access_token] и params[:user_id]
# 4) profit!

